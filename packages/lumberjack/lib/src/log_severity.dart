import 'package:quiver_hashcode/hashcode.dart';

/// A constant type that repsents the severity logged messages.
///
/// Corresponds with [RFC5424]().
/// Messages with a lower numerical priority are of higher severity, and greater pertinence.
class LogSeverity implements Comparable<LogSeverity> {
  /// A log of priority `0`. In [RFC5424], this means `system is unusable`.
  ///
  /// This is the most severe log level.
  static const LogSeverity emergency = const LogSeverity('emergency', 0);

  /// A log of priority `1`. In [RFC5424], this means `action must be taken immediately`.
  static const LogSeverity alert = const LogSeverity('alert', 1);

  /// A log of priority `2`. In [RFC5424], this means `critical conditions`.
  static const LogSeverity critical = const LogSeverity('critical', 2);

  /// A log of priority `3`. In [RFC5424], this means `error conditions`.
  static const LogSeverity error = const LogSeverity('error', 3);

  /// A log of priority `4`. In [RFC5424], this means `warning conditions`.
  static const LogSeverity warning = const LogSeverity('warning', 4);

  /// A log of priority `5`. In [RFC5424], this means `normal but significant condition`.
  static const LogSeverity notice = const LogSeverity('notice', 5);

  /// A log of priority `6`. In [RFC5424], this means `informational messages`.
  static const LogSeverity information = const LogSeverity('informational', 6);

  /// A log of priority `7`. In [RFC5424], this means `debug-level messages`.
  static const LogSeverity debug = const LogSeverity('debug', 7);

  /// The name of this log level, to appear in printed messages.
  final String name;

  /// The numerical severity of this log leve, used for comparisons.
  final int severity;

  const LogSeverity(this.name, this.severity);

  @override
  int get hashCode => hash2(name, severity);

  bool operator <=(LogSeverity other) {
    return severity <= other.severity;
  }

  bool operator >=(LogSeverity other) {
    return severity >= other.severity;
  }

  @override
  bool operator ==(other) {
    return other is LogSeverity && other.severity == severity;
  }

  @override
  int compareTo(LogSeverity other) {
    return severity.compareTo(other.severity);
  }
}
