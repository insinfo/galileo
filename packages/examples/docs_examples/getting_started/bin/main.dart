import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);
  app.get('/', (req, res) => res.write('Hello, world!'));

  app.get('/headers', (req, res) {
    req.headers.forEach((key, values) {
      res.write('$key=$values');
      res.writeln();
    });
  });

  app.post('/greet', (req, res) async {
    await req.parseBody();

    var name = req.bodyAsMap['name'] as String;

    if (name == null) {
      throw GalileoHttpException.badRequest(message: 'Missing name.');
    } else {
      res.write('Hello, $name!');
    }
  });

  var oldErrorHandler = app.errorHandler;

  app.errorHandler = (e, req, res) {
    if (e.statusCode == 400) {
      res.write('Oops! You forgot to include your name.');
    } else {
      return oldErrorHandler(e, req, res);
    }
  };

  await http.startServer('localhost', 3000);
}
