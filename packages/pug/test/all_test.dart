import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_pug/galileo_pug.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:test/test.dart';

main() {
  Galileo app;
  TestClient client;

  setUp(() async {
    app = new Galileo()
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
