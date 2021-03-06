import 'dart:async';
import 'dart:io';

import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_hot/galileo_hot.dart';
import 'package:logging/logging.dart';
import 'package:star_wars/src/pretty_logging.dart' as star_wars;
import 'package:star_wars/star_wars.dart' as star_wars;

main() async {
  Future<Galileo> createServer() async {
    hierarchicalLoggingEnabled = true;
    var logger = Logger.detached('star_wars')..onRecord.listen(star_wars.prettyLog);
    var app = Galileo(logger: logger, reflector: MirrorsReflector());
    await app.configure(star_wars.configureServer);
    return app;
  }

  var hot = HotReloader(createServer, [Directory('lib')]);

  var server = await hot.startServer('127.0.0.1', 3000);
  var serverUrl = Uri(scheme: 'http', host: server.address.address, port: server.port);
  var graphiQLUrl = serverUrl.replace(path: '/graphiql');
  print('Listening at $serverUrl');
  print('GraphiQL endpoint: $graphiQLUrl');
}
