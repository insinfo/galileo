import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_html/galileo_html.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:html_builder/elements.dart';
import 'package:html_builder/html_builder.dart';
import 'package:test/test.dart';

main() {
  Galileo app;
  TestClient client;

  setUp(() async {
    app = new Galileo();

    app.fallback(renderHtml());

    app.get('/html', (req, res) {
      return html(c: [
        head(c: [
          title(c: [text('ok')])
        ])
      ]);
    });

    app.get(
      '/strict',
      chain([
        renderHtml(
          enforceAcceptHeader: true,
          renderer: new StringRenderer(
            doctype: null,
            pretty: false,
          ),
        ),
        (req, res) {
          return div(c: [text('strict')]);
        },
      ]),
    );
    client = await connectTo(app);
  });

  tearDown(() => client.close());

  test('sets content type and body', () async {
    var response = await client.get('/html');
    print('Response: ${response.body}');

    expect(
        response,
        allOf(
            hasContentType('text/html'),
            hasBody(
                '<!DOCTYPE html><html><head><title>ok</title></head></html>')));
  });

  group('enforce accept header', () {
    test('sends if correct accept or wildcard', () async {
      var response = await client.get('/strict', headers: {'accept': '*/*'});
      print('Response: ${response.body}');
      expect(response,
          allOf(hasContentType('text/html'), hasBody('<div>strict</div>')));

      response = await client.get('/strict',
          headers: {'accept': 'text/html,application/json,text/xml'});
      print('Response: ${response.body}');
      expect(response,
          allOf(hasContentType('text/html'), hasBody('<div>strict</div>')));
    });

    test('throws if incorrect or no accept', () async {
      var response = await client.get('/strict');
      print('Response: ${response.body}');
      expect(response, hasStatus(406));

      response = await client
          .get('/strict', headers: {'accept': 'application/json,text/xml'});
      print('Response: ${response.body}');
      expect(response,
          isGalileoHttpException(statusCode: 406, message: '406 Not Acceptable'));
    });
  });
}
