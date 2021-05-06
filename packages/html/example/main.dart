import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_html/galileo_html.dart';
import 'package:html_builder/elements.dart';
import 'package:logging/logging.dart';

main() async {
  var app = Galileo(), http = GalileoHttp(app);
  app.logger = Logger('galileo_html')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

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
        renderer: StringRenderer(
          doctype: null,
          pretty: false,
        ),
      ),
      (req, res) {
        return div(c: [text('strict')]);
      },
    ]),
  );

  app.fallback((req, res) => throw GalileoHttpException.notFound());

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
