import 'dart:io';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_shelf/galileo_shelf.dart';
import 'package:logging/logging.dart';
import 'package:galileo_pretty_logging/galileo_pretty_logging.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

main() async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(prettyLog);

  // Create a basic Galileo server, with some routes.
  var app = Galileo(
    logger: Logger('galileo_shelf_demo'),
    reflector: MirrorsReflector(),
  );

  app.get('/galileo', (req, res) {
    res.write('Galileo embedded within shelf!');
    return false;
  });

  app.get('/hello', ioc((@Query('name') String name) {
    return {'hello': name};
  }));

  // Next, create an GalileoShelf driver.
  //
  // If we have startup hooks we want to run, we need to call
  // `startServer`. Otherwise, it can be omitted.
  // Of course, if you call `startServer`, know that to run
  // shutdown/cleanup logic, you need to call `close` eventually,
  // too.
  var galileoShelf = GalileoShelf(app);
  await galileoShelf.startServer();

  // Create, and mount, a shelf pipeline...
  // You can also embed Galileo as a middleware...
  var mwHandler = shelf.Pipeline()
      .addMiddleware(galileoShelf.middleware)
      .addHandler(createStaticHandler('.', defaultDocument: 'index.html', listDirectories: true));

  // Run the servers.
  await shelf_io.serve(mwHandler, InternetAddress.loopbackIPv4, 8080);
  await shelf_io.serve(galileoShelf.handler, InternetAddress.loopbackIPv4, 8081);
  print('Galileo as middleware: http://localhost:8080');
  print('Galileo as only handler: http://localhost:8081');
}
