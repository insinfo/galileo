import 'package:galileo_framework/galileo_framework.dart';
import 'dart:convert';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

main() {
  test('named constructors', () {
    expect(GalileoHttpException.badRequest(), isException(400, '400 Bad Request'));
    expect(GalileoHttpException.notAuthenticated(), isException(401, '401 Not Authenticated'));
    expect(GalileoHttpException.paymentRequired(), isException(402, '402 Payment Required'));
    expect(GalileoHttpException.forbidden(), isException(403, '403 Forbidden'));
    expect(GalileoHttpException.notFound(), isException(404, '404 Not Found'));
    expect(GalileoHttpException.methodNotAllowed(), isException(405, '405 Method Not Allowed'));
    expect(GalileoHttpException.notAcceptable(), isException(406, '406 Not Acceptable'));
    expect(GalileoHttpException.methodTimeout(), isException(408, '408 Timeout'));
    expect(GalileoHttpException.conflict(), isException(409, '409 Conflict'));
    expect(GalileoHttpException.notProcessable(), isException(422, '422 Not Processable'));
    expect(GalileoHttpException.notImplemented(), isException(501, '501 Not Implemented'));
    expect(GalileoHttpException.unavailable(), isException(503, '503 Unavailable'));
  });

  test('fromMap', () {
    expect(GalileoHttpException.fromMap({'status_code': -1, 'message': 'ok'}), isException(-1, 'ok'));
  });

  test('toMap = toJson', () {
    var exc = GalileoHttpException.badRequest();
    expect(exc.toMap(), exc.toJson());
    var json_ = json.encode(exc.toJson());
    var exc2 = GalileoHttpException.fromJson(json_);
    expect(exc2.toJson(), exc.toJson());
  });

  test('toString', () {
    expect(GalileoHttpException(null, statusCode: 420, message: 'Blaze It').toString(), '420: Blaze It');
  });
}

Matcher isException(int statusCode, String message) => _IsException(statusCode, message);

class _IsException extends Matcher {
  final int statusCode;
  final String message;

  _IsException(this.statusCode, this.message);

  @override
  Description describe(Description description) =>
      description.add('has status code $statusCode and message "$message"');

  @override
  bool matches(item, Map matchState) {
    return item is GalileoHttpException && item.statusCode == statusCode && item.message == message;
  }
}
