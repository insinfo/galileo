import 'package:galileo_framework/galileo_framework.dart';
import 'package:test/test.dart';

main() {
  test('default view generator', () async {
    var app = Galileo();
    var view = await app.viewGenerator('foo', {'bar': 'baz'});
    expect(view, contains('No view engine'));
  });
}
