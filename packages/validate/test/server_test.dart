import 'dart:async';
import 'dart:convert';

import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
//import 'package:galileo_test/galileo_test.dart';
import 'package:galileo_validate/server.dart';
import 'package:logging/logging.dart';
import 'package:galileo_mock_request/galileo_mock_request.dart';
import 'package:test/test.dart';

final Validator echoSchema = Validator({'message*': isString});

void printRecord(LogRecord rec) {
  print(rec);
  if (rec.error != null) print(rec.error);
  if (rec.stackTrace != null) print(rec.stackTrace);
}

void main() {
  Galileo app;
  GalileoHttp http;
  //TestClient client;

  setUp(() async {
    app = Galileo();
    http = GalileoHttp(app, useZone: false);

    app.chain([validate(echoSchema)]).post('/echo', (RequestContext req, res) async {
      await req.parseBody();
      res.write('Hello, ${req.bodyAsMap['message']}!');
    });

    app.logger = Logger('galileo')..onRecord.listen(printRecord);
    //client = await connectTo(app);
  });

  tearDown(() async {
    //await client.close();
    await http.close();
    app = null;
    //client = null;
  });

  group('echo', () {
    //test('validate', () async {
    //  var response = await client.post('/echo',
    //      body: {'message': 'world'}, headers: {'accept': '*/*'});
    //  print('Response: ${response.body}');
    //  expect(response, hasStatus(200));
    //  expect(response.body, equals('Hello, world!'));
    //});

    test('enforce', () async {
      var rq = MockHttpRequest('POST', Uri(path: '/echo'))
        ..headers.add('accept', '*/*')
        ..headers.add('content-type', 'application/json')
        ..write(json.encode({'foo': 'bar'}));

      scheduleMicrotask(() async {
        await rq.close();
        await http.handleRequest(rq);
      });

      var responseBody = await rq.response.transform(utf8.decoder).join();
      print('Response: $responseBody');
      expect(rq.response.statusCode, 400);
    });
  });
}
