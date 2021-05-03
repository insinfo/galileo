import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_pug/angel_pug.dart';
import 'package:angel_test/angel_test.dart';
import 'package:test/test.dart';

main() {
  Angel app;
  TestClient client;

  setUp(() async {
    app = new Angel()
      ..get('/foo', (req, res) => res.render('foo'))
      ..get('/bar', (req, res) => res.render('bar/baz'));
    await app.configure(pug(new Directory('test/views')));
    client = await connectTo(app);
  });

  tearDown(() => client.close());

  test('top-level', () async {
    var response = await client.get('/foo');
    expect(response,
        allOf(hasStatus(200), hasBody(), hasContentType(ContentType.HTML)));
  });

  test('child directory', () async {
    var response = await client.get('/bar');
    expect(response,
        allOf(hasStatus(200), hasBody(), hasContentType(ContentType.HTML)));
  });
}
