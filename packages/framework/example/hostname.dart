import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:logging/logging.dart';

Future<void> apiConfigurer(Galileo app) async {
  app.get('/', (req, res) => 'Hello, API!');
  app.fallback((req, res) {
    return 'fallback on ${req.uri} (within the API)';
  });
}

Future<void> frontendConfigurer(Galileo app) async {
  app.fallback((req, res) => '(usually an index page would be shown here.)');
}

main() async {
  // Logging set up/boilerplate
  hierarchicalLoggingEnabled = true;
  //Logger.root.onRecord.listen(prettyLog);

  var app = Galileo(logger: Logger('galileo'));
  var http = GalileoHttp(app);
  var multiHost = HostnameRouter.configure({
    'api.localhost:3000': apiConfigurer,
    'localhost:3000': frontendConfigurer,
  });

  app
    ..fallback(multiHost.handleRequest)
    ..fallback((req, res) {
      res.write('Uncaught hostname: ${req.hostname}');
    });

  app.errorHandler = (e, req, res) {
    print(e.message ?? e.error ?? e);
    print(e.stackTrace);
    return e.toJson();
  };

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
  print('See what happens when you visit http://localhost:3000 instead '
      'of http://127.0.0.1:3000. Then, try '
      'http://api.localhost:3000.');
}
