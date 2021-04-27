import 'dart:io';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

main() {
  Galileo app;
  http.Client client;
  HttpServer server;
  String url;

  setUp(() async {
    app = Galileo(reflector: MirrorsReflector())
      ..post('/foo', (req, res) => res.serialize({'hello': 'world'}))
      ..all('*', (req, res) => throw GalileoHttpException.notFound());
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

  test("allow override of method", () async {
    var response = await client.get(Uri.parse('$url/foo'), headers: {'X-HTTP-Method-Override': 'POST'});
    print('Response: ${response.body}');
    expect(json.decode(response.body), equals({'hello': 'world'}));
  });
}
