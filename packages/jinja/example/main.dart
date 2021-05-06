import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_jinja/galileo_jinja.dart';
import 'package:path/path.dart' as p;

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);
  var viewsDir = p.join(
    p.dirname(
      p.fromUri(Platform.script),
    ),
    'views',
  );

  // Enable Jinja2 views
  await app.configure(jinja(path: viewsDir));

  // Add routes.
  // See: https://github.com/ykmnkmi/jinja.dart/blob/master/example/bin/server.dart

  app
    ..get('/', (req, res) => res.render('index.html'))
    ..get('/hello', (req, res) => res.render('hello.html', {'name': 'user'}))
    ..get('/hello/:name', (req, res) => res.render('hello.html', req.params));

  app.fallback((req, res) {
    res
      ..statusCode = 404
      ..write('404 Not Found :(');
  });

  // Start the server
  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
