import 'dart:async';
import 'package:meta/meta.dart';
import 'child_logger.dart';
import 'log_severity.dart';
import 'log.dart';
import 'logger.dart';

/// A base [Logger] that is aware of its children.
abstract class HierarchicalLogger extends Logger {
  final String name;
  final List<Logger> _children = [];
  final Completer _done = new Completer();

  final StreamController<Log> _onLog = new StreamController();

  HierarchicalLogger(this.name) : super.base();

  @protected
  String get fullName => name;

  @override
  Future get done => _done.future;

  @override
  StreamSubscription<Log> listen(void Function(Log event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _onLog.stream.listen(onData, onError: onError, onDone: () {
      if (!_done.isCompleted) _done.complete();
      return onDone();
    }, cancelOnError: cancelOnError);
  }

  void log(LogSeverity severity, message,
      {Object error, StackTrace stackTrace}) {
    add(new Log(
        name, new DateTime.now(), severity, message, error, stackTrace));
  }

  /// Emit a [Log] message.
  @protected
  void add(Log log) {
    if (!_onLog.isClosed) _onLog.add(log);
  }

  @protected
  void addFromChild(ChildLogger child, Log log) {
    log = new Log('$name.${log.loggerName}', log.time, log.severity,
        log.message, log.error, log.stackTrace);
    add(log);
  }

  @override
  Logger createChild(String name, {bool bubbleOnly = false}) {
    var child = new ChildLogger(this, name, bubbleOnly);
    _children.add(child);
    return child;
  }

  @override
  Future close() {
    _children.forEach((c) => c.close());
    _onLog.close();
    if (!_done.isCompleted) _done.complete();
    return new Future.value();
  }
}
