import 'dart:io';

import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';

main() {
  Galileo app;
  http.Client client;
  HttpServer server;
  String url;

  setUp(() async {
    app = Galileo(reflector: MirrorsReflector())
      ..get('/foo', ioc(() => {'hello': 'world'}))
      ..get('/bar', (req, res) async {
        await res.serialize({'hello': 'world'}, contentType: MediaType('text', 'html'));
      });
    client = http.Client();

    server = await GalileoHttp(app).startServer();
    url = "http://${server.address.host}:${server.port}";
  });

  tearDown(() async {
    app = null;
    url = null;
    client.close();
    client = null;
    await server.close(force: true);
  });

  test("correct content-type", () async {
    var response = await client.get(Uri.parse('$url/foo'));
    print('Response: ${response.body}');
    expect(response.headers['content-type'], contains('application/json'));

    response = await client.get(Uri.parse('$url/bar'));
    print('Response: ${response.body}');
    expect(response.headers['content-type'], contains('text/html'));
  });
}
