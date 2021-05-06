import 'dart:io';
import 'package:galileo/src/pretty_logging.dart';
import 'package:galileo/galileo.dart';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_hot/galileo_hot.dart';
import 'package:logging/logging.dart';

main() async {
  // Watch the config/ and web/ directories for changes, and hot-reload the server.
  hierarchicalLoggingEnabled = true;

  var hot = HotReloader(() async {
    var logger = Logger.detached('{{galileo}}')
      ..level = Level.ALL
      ..onRecord.listen(prettyLog);
    var app = Galileo(logger: logger, reflector: MirrorsReflector());
    await app.configure(configureServer);
    return app;
  }, [
    Directory('config'),
    Directory('lib'),
  ]);

  var server = await hot.startServer('127.0.0.1', 3000);
  print(
      '{{galileo}} server listening at http://${server.address.address}:${server.port}');
}
