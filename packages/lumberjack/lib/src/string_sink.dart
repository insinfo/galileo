import 'dart:async';
import 'package:intl/intl.dart';
import 'package:lumberjack/lumberjack.dart';

/// A [StreamConsumer] that prints messages to a [StringSink].
class StringSinkPrinter extends StreamConsumer<Log> {
  /// The format in which to write the timestamps of [Log] messages.
  ///
  /// Defaults to `yMd_Hms`.
  final DateFormat dateFormat;

  /// The [StringSink] to write to.
  final StringSink sink;

  StringSinkPrinter(this.sink, {DateFormat dateFormat})
      : this.dateFormat =
            dateFormat ?? new DateFormat("EEE, MMM d, yyyy @ HH:mm:ss");
  @override
  Future addStream(Stream<Log> stream) {
    var c = new Completer();
    stream.listen((log) {
      if (log.message == null && log.error == null && log.stackTrace == null)
        return;

      var b = new StringBuffer();
      b.write('[${dateFormat.format(log.time)}] ');
      b.write('${log.severity.name}:');
      b.write(' ');
      b.write('${log.loggerName}: ');
      if (log.message != null) b.write(log.message.toString());
      b.writeln();
      if (log.error != null) b.write(log.error.toString());
      if (log.stackTrace != null) b.write(log.stackTrace.toString());
      sink.write(b);
    }, onDone: c.complete, onError: c.completeError);
    return c.future;
  }

  @override
  Future close() {
    return new Future.value();
  }
}
