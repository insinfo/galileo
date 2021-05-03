import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:io/ansi.dart';
import 'package:lumberjack/lumberjack.dart';

/// A [StreamConsumer] that prints colorful messages by means of [AnsiCode].
class AnsiLogPrinter extends StreamConsumer<Log> {
  /// Determines which background color to use to display a [Log] message.
  final Map<LogSeverity, AnsiCode> backgroundColors = {};

  /// Determines which foreground color to use to display a [Log] message.
  final Map<LogSeverity, AnsiCode> foregroundColors = {};

  /// The format in which to write the timestamps of [Log] messages.
  ///
  /// Defaults to `yMd_Hms`.
  final DateFormat dateFormat;

  /// The [IOSink] to write to. Oftentimes, this is [stdout].
  final IOSink sink;

  bool _isStdout = false;

  AnsiLogPrinter(this.sink,
      {DateFormat dateFormat,
      Map<LogSeverity, AnsiCode> backgroundColors = const {},
      Map<LogSeverity, AnsiCode> foregroundColors = const {}})
      : this.dateFormat =
            dateFormat ?? new DateFormat("EEE, MMM d, yyyy @ HH:mm:ss") {
    this.backgroundColors.addAll(backgroundColors ?? {});
    this.foregroundColors.addAll(foregroundColors ?? {});
  }

  /// Creates an [AnsiLogPrinter] that writes to stdout.
  ///
  /// Does not close [stdout] after [close] is called.
  factory AnsiLogPrinter.toStdout(
          {DateFormat dateFormat,
          Map<LogSeverity, AnsiCode> backgroundColors = const {},
          Map<LogSeverity, AnsiCode> foregroundColors = const {}}) =>
      new AnsiLogPrinter(stdout,
          backgroundColors: backgroundColors,
          foregroundColors: foregroundColors,
          dateFormat: dateFormat)
        .._isStdout = true;

  /// Chooses a background color based on the logger [severity].
  AnsiCode chooseBackground(LogSeverity severity) {
    if (backgroundColors.containsKey(severity))
      return backgroundColors[severity];
    else if (severity <= LogSeverity.error)
      return backgroundRed;
    else if (severity <= LogSeverity.warning)
      return backgroundYellow;
    else if (severity <= LogSeverity.notice)
      return backgroundMagenta;
    else if (severity <= LogSeverity.information)
      return backgroundCyan;
    else if (severity <= LogSeverity.debug) return backgroundGreen;
    return backgroundDefault;
  }

  /// Chooses a foreground color based on the logger [severity].
  AnsiCode chooseForeground(LogSeverity severity) {
    if (foregroundColors.containsKey(severity))
      return foregroundColors[severity];
    else if (severity <= LogSeverity.error)
      return red;
    else if (severity <= LogSeverity.warning)
      return yellow;
    else if (severity <= LogSeverity.notice)
      return magenta;
    else if (severity <= LogSeverity.information)
      return cyan;
    else if (severity <= LogSeverity.debug) return green;
    return resetAll;
  }

  @override
  Future addStream(Stream<Log> stream) {
    var c = new Completer();

    stream.listen((log) {
      if (log.message == null && log.error == null && log.stackTrace == null)
        return;

      var background = chooseBackground(log.severity);
      var foreground = chooseForeground(log.severity);
      var b = new StringBuffer();
      b.write(foreground.wrap('[${dateFormat.format(log.time)}] '));
      b.write(wrapWith('${log.severity.name}:', [background, white]));
      b.write(' ');
      b.write(foreground.wrap('${log.loggerName}: '));
      if (log.message != null) b.write(foreground.wrap(log.message.toString()));
      b.writeln();
      if (log.error != null) b.write(foreground.wrap(log.error.toString()));
      if (log.stackTrace != null)
        b.write(foreground.wrap(log.stackTrace.toString()));
      sink.write(b);
    }, onDone: c.complete, onError: c.completeError);
    return c.future;
  }

  @override
  Future close() {
    if (!_isStdout) return sink.close();
    return new Future.value();
  }
}
