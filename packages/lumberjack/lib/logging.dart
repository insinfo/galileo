import 'package:logging/logging.dart' as dart;
import 'src/root_logger.dart';
import 'lumberjack.dart';

/// A [Logger] that wraps a [dart.Logger] from `package:logging`.
class ConvertingLogger extends RootLogger {
  final dart.Logger logger;

  /// Translates a [level] into a [LogSeverity].
  static LogSeverity convertLevel(dart.Level level) {
    if (level == dart.Level.SHOUT) return LogSeverity.emergency;
    if (level == dart.Level.SEVERE) return LogSeverity.error;
    if (level == dart.Level.WARNING) return LogSeverity.warning;
    if (level == dart.Level.INFO) return LogSeverity.information;
    if (level == dart.Level.FINE ||
        level == dart.Level.FINER ||
        level == dart.Level.FINEST)
      return LogSeverity.debug;
    else
      return LogSeverity.information;
  }

  static dart.Level convertSeverity(LogSeverity severity) {
    if (severity <= LogSeverity.error)
      return dart.Level.SHOUT;
    else if (severity <= LogSeverity.warning)
      return dart.Level.WARNING;
    else if (severity <= LogSeverity.notice)
      return dart.Level.CONFIG;
    else if (severity <= LogSeverity.information)
      return dart.Level.INFO;
    else if (severity <= LogSeverity.debug) return dart.Level.FINE;
    return dart.Level.INFO;
  }

  ConvertingLogger(this.logger) : super(logger.fullName) {
    logger.onRecord.listen((rec) {
      var log = new Log(rec.loggerName, rec.time, convertLevel(rec.level),
          rec.message, rec.error, rec.stackTrace);
      if (rec.stackTrace is! _ConvertedStackTrace) add(log);
    });
  }

  @override
  void log(LogSeverity severity, message,
      {Object error, StackTrace stackTrace}) {
    super.log(severity, message, error: error, stackTrace: stackTrace);
    logger.log(convertSeverity(severity), message, error,
        new _ConvertedStackTrace(stackTrace));
  }

  @override
  Future close() {
    logger.clearListeners();
    return super.close();
  }
}

class _ConvertedStackTrace implements StackTrace {
  final StackTrace inner;

  _ConvertedStackTrace(this.inner);
}
