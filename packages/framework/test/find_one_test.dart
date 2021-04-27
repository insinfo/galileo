import 'package:galileo_framework/galileo_framework.dart';
import 'package:test/test.dart';
import 'common.dart';

void main() {
  var throwsAnGalileoHttpException = throwsA(const IsInstanceOf<GalileoHttpException>());

  test('throw 404 on null', () {
    var service = AnonymousService(index: ([p]) => null);
    expect(() => service.findOne(), throwsAnGalileoHttpException);
  });

  test('throw 404 on empty iterable', () {
    var service = AnonymousService(index: ([p]) => []);
    expect(() => service.findOne(), throwsAnGalileoHttpException);
  });

  test('return first element of iterable', () async {
    var service = AnonymousService(index: ([p]) => [2]);
    expect(await service.findOne(), 2);
  });
}
