import 'dart:convert';
import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_proxy/galileo_proxy.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:logging/logging.dart';
import 'package:galileo_mock_request/galileo_mock_request.dart';
import 'package:test/test.dart';

main() {
  Galileo app, testApp;
  TestClient client;
  Proxy layer;

  setUp(() async {
    testApp = Galileo();
    testApp.get('/foo', (req, res) async {
      res.useBuffer();
      res.write('pub serve');
    });
    testApp.get('/empty', (req, res) => res.close());

    testApp.responseFinalizers.add((req, res) async {
      print('OUTGOING: ' + String.fromCharCodes(res.buffer.toBytes()));
    });

    testApp.encoders.addAll({'gzip': gzip.encoder});

    var server = await GalileoHttp(testApp).startServer();

    app = Galileo();
    app.fallback((req, res) {
      res.useBuffer();
      return true;
    });
    app.get('/bar', (req, res) => res.write('normal'));

    layer = Proxy(
      Uri(scheme: 'http', host: server.address.address, port: server.port),
      publicPath: '/proxy',
    );

    app.fallback(layer.handleRequest);

    app.responseFinalizers.add((req, res) async {
      print('Normal. Buf: ' + String.fromCharCodes(res.buffer.toBytes()) + ', headers: ${res.headers}');
    });

    app.encoders.addAll({'gzip': gzip.encoder});

    client = await connectTo(app);

    app.logger = testApp.logger = Logger('proxy')
      ..onRecord.listen((rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      });
  });

  tearDown(() async {
    await client.close();
    await app.close();
    await testApp.close();
    app = null;
    testApp = null;
  });

  test('proxied', () async {
    var rq = MockHttpRequest('GET', Uri.parse('/proxy/foo'));
    await rq.close();
    var rqc = await HttpRequestContext.from(rq, app, '/proxy/foo');
    var rsc = HttpResponseContext(rq.response, app);
    await app.executeHandler(layer.handleRequest, rqc, rsc);
    var response = await rq.response
        //.transform(gzip.decoder)
        .transform(utf8.decoder)
        .join();
    expect(response, 'pub serve');
  });

  test('empty', () async {
    var response = await client.get(Uri.parse('/proxy/empty'));
    expect(response.body, isEmpty);
  });

  test('normal', () async {
    var response = await client.get(Uri.parse('/bar'));
    expect(response, hasBody('normal'));
  });
}
