import 'dart:async';
import 'dart:io';

import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:logging/logging.dart';

Future<HttpServer> startTestServer() {
  final app = Galileo();

  app.get('/hello', (req, res) => res.write('world'));
  app.get('/foo/bar', (req, res) => res.write('baz'));
  app.post('/body', (RequestContext req, res) async {
    var body = await req.parseBody().then((_) => req.bodyAsMap);
    app.logger.info('Body: $body');
    return body;
  });

  app.logger = Logger('testApp');
  var server = GalileoHttp(app);
  app.dumpTree();

  return server.startServer();
}
