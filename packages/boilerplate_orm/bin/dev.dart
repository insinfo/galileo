import 'dart:io';
import 'package:galileo/src/pretty_logging.dart';
import 'package:galileo/galileo.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_hot/galileo_hot.dart';
import 'package:logging/logging.dart';

main() async {
  // Watch the config/ and web/ directories for changes, and hot-reload the server.
  var hot = new HotReloader(() async {
    var app = new Galileo()..lazyParseBodies = true;
    await app.configure(configureServer);
    app.logger = new Logger('galileo')
      ..onRecord.listen(prettyLog);
    return app;
  }, [
    new Directory('config'),
    new Directory('lib'),
  ]);

  var server = await hot.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
