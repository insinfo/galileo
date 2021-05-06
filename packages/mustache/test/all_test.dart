import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_mustache/galileo_mustache.dart';
import 'package:file/local.dart';
import 'package:test/test.dart';

main() async {
  Galileo galileo = new Galileo();
  await galileo.configure(mustache(const LocalFileSystem().directory('./test')));

  test('can render templates', () async {
    var hello = await galileo.viewGenerator('hello', {'name': 'world'});
    var bar = await galileo.viewGenerator('foo/bar', {'framework': 'galileo'});

    expect(hello, equals("Hello, world!"));
    expect(bar, equals("galileo_framework"));
  });

  test('throws if view is not found', () {
    expect(new Future(() async {
      var fails = await galileo.viewGenerator('fail', {'this_should': 'fail'});
      print(fails);
    }), throws);
  });

  test("partials", () async {
    var withPartial = await galileo.viewGenerator('with-partial');
    expect(withPartial, equals("Hello, world!"));
  });
}
