import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:uuid/uuid.dart';
import 'protocol.dart';
import 'task_result.dart';
import 'task_result_impl.dart';

/// Interacts with a remote task engine, whether over isolates or TCP sockets.
class AngelTaskClient {
  final Completer _connect = new Completer();
  final Map<String, Completer<Message>> _awaiting = {};
  String _id;
  final StreamController _onBroadcast = new StreamController();
  ReceivePort _receivePort;
  final Uuid _uuid = new Uuid();

  /// Fired whenever the master isolate broadcasts an event.
  Stream get onBroadcast => _onBroadcast.stream;

  /// A receive port that the master isolate sends messages along.
  ReceivePort get receivePort => _receivePort;

  /// A [SendPort] that points back to a master isolate.
  final SendPort server;

  AngelTaskClient(this.server);

  /// Connects a task client to a TCP socket.
  static Future<AngelTaskClient> fromSocket(Socket socket) async {
    return new _SocketTaskClientImpl(socket).._listen();
  }

  _sendToServer(Message message) {
    server.send(message.toJson());
  }

  /// Connects to the remote isolate. Provide a [timeout] if necessary.
  Future connect({Duration timeout}) {
    if (_connect.isCompleted)
      throw new StateError('This TaskClient is already connected!');
    _receivePort = new ReceivePort()..listen(handleMessage);
    var c = new Completer();
    server.send(
        new Message(MessageType.REQUEST_ID, sendPort: _receivePort.sendPort));
    Timer timer;

    _connect.future.then((_) {
      if (!c.isCompleted) {
        c.complete();
        timer?.cancel();
      }
    }).catchError(c.completeError);

    if (timeout != null) {
      timer = new Timer(timeout, () {
        if (!c.isCompleted)
          c.completeError(new TimeoutException(
              'TaskClient connect exceeded timeout of ${timeout.inMilliseconds}ms.',
              timeout));
      });
    }

    return c.future;
  }

  /// Processes the result of an incoming message.
  handleMessage(Map data) {
    var message = Message.parse(data);

    switch (message.type) {
      case MessageType.ASSIGNED_ID:
        if (_id == null) {
          _connect.complete(_id = message.clientId);
        }
        break;
      case MessageType.TASK_COMPLETED:
        var completer = _awaiting.remove(message.messageId);
        completer?.complete(message);
        break;
      case MessageType.BROADCAST:
        _onBroadcast.add(message.broadcastValue);
        break;
      default:
        break;
    }
  }

  Future close() async {
    receivePort?.close();
    _onBroadcast.close();
    _awaiting.clear();
  }

  /// Triggers a task on the remote engine. You can pass [args], and [named] parameters.
  ///
  /// Provide a [timeout] if you expect the response to complete within a certain amount of time.
  Future<TaskResult> run(String name,
      {List args, Map<String, dynamic> named, @deprecated Duration timeout}) {
    var c = new Completer<TaskResult>();
    var id = _uuid.v4();
    Timer timer;

    _sendToServer(new Message(MessageType.RUN_TASK,
        taskName: name, args: args, named: named));

    var msg = _awaiting[id] = new Completer<Message>();

    msg.future.then((message) {
      timer?.cancel();
      if (!c.isCompleted) c.complete(TaskResultImpl.parse(message.taskResult));
    }).catchError(c.completeError);

    return c.future;
  }
}

class _SocketTaskClientImpl extends AngelTaskClient {
  final Socket socket;

  _SocketTaskClientImpl(this.socket) : super(null);

  @override
  Future close() async {
    await socket.close();
    await super.close();
  }

  @override
  Future connect({timeout}) => new Future.value(null);

  @override
  _sendToServer(Message message) {
    socket.write(JSON.encode(message.toJson()));
    socket.flush();
  }

  void _listen() {
    socket.listen((buf) {
      try {
        var val = JSON.decode(UTF8.decode(buf));
        if (val is Map) handleMessage(val);
      } catch (e) {
        // Ignore parse error
      }
    });
  }
}
