import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:angel_framework/angel_framework.dart';
import 'package:uuid/uuid.dart';
import 'protocol.dart';
import 'scheduler.dart';
import 'task.dart';
import 'task_result_impl.dart';

/// Schedules and runs tasks within the context of a loaded application.
class AngelTaskScheduler extends TaskScheduler {
  final Map<String, SendPort> _clients = {};
  bool _closed = false;
  final List<Socket> _clientSockets = [];
  bool _started = false;
  final List<_TaskImpl> _tasks = [];
  final Uuid _uuid = new Uuid();
  final Angel app;
  final bool sendReturnValues;
  final ServerSocket socket;
  final ReceivePort receivePort = new ReceivePort();

  AngelTaskScheduler(this.app, {this.sendReturnValues: false, this.socket});

  /// Sends an arbitrary message to all connected clients.
  void broadcast(message) {
    var msg =
        new Message(MessageType.BROADCAST, broadcastValue: message).toJson();
    _clients.values.forEach((s) => s.send(msg));
    _clientSockets.forEach((s) => s
      ..write(JSON.encode(msg))
      ..flush());
  }

  @override
  Task schedule(Duration duration, Function callback, {String name}) {
    var task = new _TaskImpl(
        app, duration, callback, callback == null ? null : preInject(callback),
        name: name);
    _tasks.add(task);
    if (_started) task.run();
    return task;
  }

  @override
  Future close() async {
    _closed = true;
    receivePort.close();
    await Future.wait(_tasks.map((t) => t.cancel()));
    await Future.wait(_clientSockets.map((s) => s.close()));
    socket?.close();
    _clientSockets.clear();
    _clients.clear();
  }

  @override
  Task once(Function callback, [Duration delay]) {
    var task = new _OnceTaskImpl(
        app, delay, callback, callback == null ? null : preInject(callback));
    _tasks.add(task);
    if (_started) task.run();
    return task;
  }

  @override
  Future run(String name, [List args, Map<Symbol, dynamic> named]) {
    var task = _tasks.firstWhere((t) => t.name != null && t.name == name,
        orElse: () =>
            throw new UnsupportedError('No task found named \'$name\'.'));
    return task.run(args, named);
  }

  @override
  Future start() {
    if (_started || _closed)
      throw new StateError('Cannot restart an AngelTaskScheduler.');

    receivePort.listen((data) {
      handleMessage(data, (message) {
        // Only send the message if there is an associated client.
        if (message.clientId != null) {
          var client = _clients[message.clientId];
          client?.send(message.toJson());
        }
      });
    });

    if (socket != null) {
      socket.listen((client) {
        client.listen((buf) async {
          Message message;

          try {
            message = Message.parse(JSON.decode(UTF8.decode(buf)));
            if (message.type == MessageType.RUN_TASK) {
              var result = await run(
                  message.taskName,
                  message.args,
                  message.named?.keys?.fold<Map<Symbol, dynamic>>({}, (out, k) {
                    return out..[new Symbol(k)] = message.named[k];
                  }));
              client.write(JSON.encode(new Message(MessageType.TASK_COMPLETED,
                  messageId: message.messageId,
                  taskResult: new TaskResultImpl(true,
                          value: sendReturnValues == true ? result : null)
                      .toJson())));
            }
          } catch (e, st) {
            client.write(JSON.encode(new Message(MessageType.TASK_COMPLETED,
                messageId: message?.messageId,
                taskResult: new TaskResultImpl(false,
                        error: e.toString(), stack: st.toString())
                    .toJson())));
          } finally {
            client.flush();
          }
        });
      });
    }

    return new Future.sync(() {
      for (var task in _tasks.where((t) => !t._closed)) {
        task._start();
      }

      _started = true;
    });
  }

  /// Handles an incoming message. You must provide a way to [send] a response.
  handleMessage(data, void send(Message message)) {
    var message = data is Message ? data : Message.parse(data);

    switch (message.type) {
      // Only called via isolates
      case MessageType.REQUEST_ID:
        var id = _uuid.v4();
        var client = _clients[id] = message.sendPort;
        client
            .send(new Message(MessageType.ASSIGNED_ID, clientId: id).toJson());
        break;
      case MessageType.RUN_TASK:
        run(
            message.taskName,
            message.args,
            message.named?.keys?.fold<Map<Symbol, dynamic>>({}, (out, k) {
              return out..[new Symbol(k)] = message.named[k];
            })).then((result) {
          send(new Message(MessageType.TASK_COMPLETED,
              messageId: message.messageId,
              taskResult: new TaskResultImpl(true,
                      value: sendReturnValues == true ? result : null)
                  .toJson()));
        }).catchError((e, st) {
          send(new Message(MessageType.TASK_COMPLETED,
              messageId: message.messageId,
              taskResult: new TaskResultImpl(false,
                      error: e.toString(), stack: st.toString())
                  .toJson()));
        });

        break;
      default:
        break;
    }
  }

  @override
  void define(String name, Function callback) {
    _tasks.add(new _TaskImpl(
        app, null, callback, callback == null ? null : preInject(callback),
        name: name));
  }
}

class _TaskImpl implements Task {
  bool _closed = false;
  final StreamController _results = new StreamController();
  Timer _timer;
  final Angel app;
  final Function callback;
  final Duration frequency;
  final String name;
  final InjectionRequest injection;

  _TaskImpl(this.app, this.frequency, this.callback, this.injection,
      {this.name});

  @override
  Stream get results => _results.stream;

  Future run([List args, Map<Symbol, dynamic> named]) async {
    if (_closed) {
      _results.addError(new StateError('Cannot run a cancelled task.'));
      throw new StateError('Cannot run a cancelled task.');
    }

    try {
      var r = await _run(callback, injection, app, args, named);
      _results.add(r);
      return r;
    } catch(e, st) {
      _results.addError(e, st);
      rethrow;
    }
  }

  void _start() {
    if (frequency != null) _timer = new Timer.periodic(frequency, (_) => run());
  }

  @override
  Future cancel() async {
    _timer?.cancel();
    _results.close();
    _closed = true;
  }

  @override
  toString() {
    if (name != null)
      return 'Task: $name';
    else
      return super.toString();
  }
}

class _OnceTaskImpl extends _TaskImpl {
  _OnceTaskImpl(
      Angel app, Duration delay, Function callback, InjectionRequest injection)
      : super(app, delay ?? new Duration(), callback, injection);

  run([List args, Map<Symbol, dynamic> named]) async {
    var result = await super.run(args, named);
    cancel();
    return result;
  }
}

_run(Function callback, InjectionRequest injection, Angel app,
    [List arguments, Map<Symbol, dynamic> namedParams]) {
  List args = []..addAll(arguments ?? []);
  Map<Symbol, dynamic> named = {}..addAll(namedParams ?? {});

  void inject(requirement) {
    if (requirement is List &&
        requirement.length >= 2 &&
        requirement[0] is String &&
        requirement[1] is Type) {
      if (app.injections.containsKey(requirement[0]))
        args.add(app.injections[requirement[0]]);
      else
        inject(requirement[1]);
    } else if (requirement is Type)
      args.add(app.injections[requirement] ?? app.container.make(requirement));
  }

  if (injection == null) return null;

  injection.required.skip(args.length).forEach(inject);
  injection.named.forEach((k, v) {
    named.putIfAbsent(new Symbol(k), () {
      if (app.injections.containsKey(k))
        return app.injections[k];
      else if (v == dynamic || v == Null || v == Object || v == null)
        throw new UnsupportedError('Cannot inject \'$k\' as type \'$v\'.');
      return app.container.make(v);
    });
  });

  return Function.apply(callback, args, named);
}
