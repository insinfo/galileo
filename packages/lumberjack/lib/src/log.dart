import 'log_severity.dart';

/// A message emitted by the system, that should be displayed or stored somewhere.
class Log {
  /// The name of the logger which created this message.
  final String loggerName;

  /// The time at which this messsage was created.
  final DateTime time;

  /// The severity of this message.
  final LogSeverity severity;

  /// The contents of this message.
  final Object message;

  /// The error associated with this object, if any.
  ///
  /// Typically used [stackTrace].
  final Object error;

  /// The [StackTrace] associated with this object, if any.
  ///
  /// Typically used with [error].
  final StackTrace stackTrace;

  Log(this.loggerName, this.time, this.severity, this.message, this.error, this.stackTrace);
}
