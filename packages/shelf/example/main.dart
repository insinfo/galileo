import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_shelf/galileo_shelf.dart';
import 'package:logging/logging.dart';
import 'package:galileo_pretty_logging/galileo_pretty_logging.dart';
import 'package:shelf_static/shelf_static.dart';

main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(prettyLog);

  var app = Galileo(logger: Logger('galileo_shelf_demo'));
  var http = GalileoHttp(app);

  // `shelf` request handler
  var shelfHandler = createStaticHandler('.', defaultDocument: 'index.html', listDirectories: true);

  // Use `embedShelf` to adapt a `shelf` handler for use within Galileo.
  var wrappedHandler = embedShelf(shelfHandler);

  // A normal Galileo route.
  app.get('/galileo', (req, ResponseContext res) {
    res.write('Hooray for `package:galileo_shelf`!');
    return false; // End execution of handlers, so we don't proxy to dartlang.org when we don't need to.
  });

  // Pass any other request through to the static file handler
  app.fallback(wrappedHandler);

  await http.startServer(InternetAddress.loopbackIPv4, 8080);
  print('Running at ${http.uri}');
}
