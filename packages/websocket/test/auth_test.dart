import 'dart:async';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_client/io.dart' as c;
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_websocket/io.dart' as c;
import 'package:galileo_websocket/server.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

const Map<String, String> USER = {'username': 'foo', 'password': 'bar'};

void main() {
  Galileo app;
  GalileoHttp http;
  c.Galileo client;
  c.WebSockets ws;

  setUp(() async {
    app = Galileo();
    http = GalileoHttp(app, useZone: false);
    var auth = GalileoAuth();

    auth.serializer = (_) async => 'baz';
    auth.deserializer = (_) async => USER;

    auth.strategies['local'] = LocalAuthStrategy(
      (username, password) async {
        if (username == 'foo' && password == 'bar') {
          return USER;
        }
      },
    );

    app.post('/auth/local', auth.authenticate('local'));

    await app.configure(auth.configureServer);
    var sock = GalileoWebSocket(app);

    await app.configure(sock.configureServer);
    app.all('/ws', sock.handleRequest);
    app.logger = Logger('galileo_auth')..onRecord.listen(print);

    var server = await http.startServer();

    client = c.Rest('http://${server.address.address}:${server.port}');

    ws = c.WebSockets('ws://${server.address.address}:${server.port}/ws');
    await ws.connect();
  });

  tearDown(() {
    http.close();
    client.close();
    ws.close();
  });

  test('auth event fires', () async {
    var localAuth = await client.authenticate(type: 'local', credentials: USER);
    print('JWT: ${localAuth.token}');

    ws.authenticateViaJwt(localAuth.token);
    var auth = await ws.onAuthenticated.first;
    expect(auth.token, localAuth.token);
  });
}
