import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:logging/logging.dart';

main() async {
  // Logging set up/boilerplate
  //Logger.root.onRecord.listen(prettyLog);

  // Create our server.
  var app = Galileo(
    logger: Logger('galileo'),
    reflector: MirrorsReflector(),
  );

  // Index route. Returns JSON.
  app.get('/', (req, res) => 'Welcome to Galileo!');

  // Accepts a URL like /greet/foo or /greet/bob.
  app.get(
    '/greet/:name',
    (req, res) {
      var name = req.params['name'];
      res
        ..write('Hello, $name!')
        ..close();
    },
  );

  // Pattern matching - only call this handler if the query value of `name` equals 'emoji'.
  app.get(
    '/greet',
    ioc((@Query('name', match: 'emoji') String name) => '😇🔥🔥🔥'),
  );

  // Handle any other query value of `name`.
  app.get(
    '/greet',
    ioc((@Query('name') String name) => 'Hello, $name!'),
  );

  // Simple fallback to throw a 404 on unknown paths.
  app.fallback((req, res) {
    throw GalileoHttpException.notFound(
      message: 'Unknown path: "${req.uri.path}"',
    );
  });

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  var url = 'http://${server.address.address}:${server.port}';
  print('Listening at $url');
  print('Visit these pages to see Galileo in action:');
  print('* $url/greet/bob');
  print('* $url/greet/?name=emoji');
  print('* $url/greet/?name=jack');
  print('* $url/nonexistent_page');
}
