import 'dart:io';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart' as srv;
import 'package:galileo_framework/http.dart' as srv;
import 'package:galileo_websocket/io.dart' as ws;
import 'package:galileo_websocket/server.dart' as srv;
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'common.dart';

void main() {
  srv.Galileo app;
  srv.GalileoHttp http;
  ws.WebSockets client;
  srv.GalileoWebSocket websockets;
  HttpServer server;
  String url;

  setUp(() async {
    app = srv.Galileo(reflector: MirrorsReflector())..use('/api/todos', TodoService());
    http = srv.GalileoHttp(app, useZone: false);

    websockets = srv.GalileoWebSocket(app)
      ..onData.listen((data) {
        print('Received by server: $data');
      });

    await app.configure(websockets.configureServer);
    app.all('/ws', websockets.handleRequest);
    app.logger = Logger('galileo_auth')..onRecord.listen(print);
    server = await http.startServer();
    url = 'ws://${server.address.address}:${server.port}/ws';

    client = ws.WebSockets(url);
    await client.connect();

    client
      ..onData.listen((data) {
        print('Received by client: $data');
      })
      ..onError.listen((error) {
        // Auto-fail tests on errors ;)
        stderr.writeln(error);
        error.errors.forEach(stderr.writeln);
        throw error;
      });
  });

  tearDown(() async {
    await client.close();
    await http.server.close(force: true);

    app = null;
    client = null;
    server = null;
    url = null;
    //exit(0);
  });

  group('service.io', () {
    test('index', () => testIndex(client));
  });
}
