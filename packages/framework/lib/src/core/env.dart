import 'dart:io';

/// A constant instance of [GalileoEnv].
const GalileoEnvironment galileoEnv = GalileoEnvironment();

/// Queries the environment's `GALILEO_ENV` value.
class GalileoEnvironment {
  final String _customValue;

  /// You can optionally provide a custom value, in order to override the system's
  /// value.
  const GalileoEnvironment([this._customValue]);

  /// Returns the value of the `GALILEO_ENV` variable; defaults to `'development'`.
  String get value => (_customValue ?? Platform.environment['GALILEO_ENV'] ?? 'development').toLowerCase();

  /// Returns whether the [value] is `'development'`.
  bool get isDevelopment => value == 'development';

  /// Returns whether the [value] is `'production'`.
  bool get isProduction => value == 'production';

  /// Returns whether the [value] is `'staging'`.
  bool get isStaging => value == 'staging';
}
