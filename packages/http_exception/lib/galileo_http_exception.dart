library galileo_http_exception;

import 'dart:convert';

/// Exception class that can be serialized to JSON and serialized to clients.
/// Carries HTTP-specific metadata, like [statusCode].
///
/// Originally inspired by
/// [feathers-errors](https://github.com/feathersjs/feathers-errors).
class GalileoHttpException implements Exception {
  var error;

  /// A list of errors that occurred when this exception was thrown.
  final List<String> errors = [];

  /// The cause of this exception.
  String? message;

  /// The [StackTrace] associated with this error.
  StackTrace? stackTrace;

  /// An HTTP status code this exception will throw.
  int? statusCode;

  GalileoHttpException(this.error,
      {this.message = '500 Internal Server Error',
      this.stackTrace,
      this.statusCode = 500,
      List<String> errors = const []}) {
    if (errors != null) {
      this.errors.addAll(errors);
    }
  }

  Map toJson() {
    return {'is_error': true, 'status_code': statusCode, 'message': message, 'errors': errors};
  }

  Map toMap() => toJson();

  @override
  String toString() {
    return '$statusCode: $message';
  }

  factory GalileoHttpException.fromMap(Map data) {
    return GalileoHttpException(
      null,
      statusCode: (data['status_code'] ?? data['statusCode']) as int?,
      message: data['message']?.toString(),
      errors:
          data['errors'] is Iterable ? ((data['errors'] as Iterable).map((x) => x.toString()).toList()) : <String>[],
    );
  }

  factory GalileoHttpException.fromJson(String str) => GalileoHttpException.fromMap(json.decode(str) as Map);

  /// Throws a 400 Bad Request error, including an optional arrray of (validation?)
  /// errors you specify.
  factory GalileoHttpException.badRequest({String message = '400 Bad Request', List<String> errors = const []}) =>
      GalileoHttpException(null, message: message, errors: errors, statusCode: 400);

  /// Throws a 401 Not Authenticated error.
  factory GalileoHttpException.notAuthenticated({String message = '401 Not Authenticated'}) =>
      GalileoHttpException(null, message: message, statusCode: 401);

  /// Throws a 402 Payment Required error.
  factory GalileoHttpException.paymentRequired({String message = '402 Payment Required'}) =>
      GalileoHttpException(null, message: message, statusCode: 402);

  /// Throws a 403 Forbidden error.
  factory GalileoHttpException.forbidden({String message = '403 Forbidden'}) =>
      GalileoHttpException(null, message: message, statusCode: 403);

  /// Throws a 404 Not Found error.
  factory GalileoHttpException.notFound({String message = '404 Not Found'}) =>
      GalileoHttpException(null, message: message, statusCode: 404);

  /// Throws a 405 Method Not Allowed error.
  factory GalileoHttpException.methodNotAllowed({String message = '405 Method Not Allowed'}) =>
      GalileoHttpException(null, message: message, statusCode: 405);

  /// Throws a 406 Not Acceptable error.
  factory GalileoHttpException.notAcceptable({String message = '406 Not Acceptable'}) =>
      GalileoHttpException(null, message: message, statusCode: 406);

  /// Throws a 408 Timeout error.
  factory GalileoHttpException.methodTimeout({String message = '408 Timeout'}) =>
      GalileoHttpException(null, message: message, statusCode: 408);

  /// Throws a 409 Conflict error.
  factory GalileoHttpException.conflict({String message = '409 Conflict'}) =>
      GalileoHttpException(null, message: message, statusCode: 409);

  /// Throws a 422 Not Processable error.
  factory GalileoHttpException.notProcessable({String message = '422 Not Processable'}) =>
      GalileoHttpException(null, message: message, statusCode: 422);

  /// Throws a 501 Not Implemented error.
  factory GalileoHttpException.notImplemented({String message = '501 Not Implemented'}) =>
      GalileoHttpException(null, message: message, statusCode: 501);

  /// Throws a 503 Unavailable error.
  factory GalileoHttpException.unavailable({String message = '503 Unavailable'}) =>
      GalileoHttpException(null, message: message, statusCode: 503);
}
