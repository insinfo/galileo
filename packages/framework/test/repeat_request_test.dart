import 'dart:async';
import 'dart:convert';

import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_mock_request/galileo_mock_request.dart';
import 'package:test/test.dart';

main() {
  MockHttpRequest mk(int id) {
    return MockHttpRequest('GET', Uri.parse('/test/$id'))..close();
  }

  test('can request the same url twice', () async {
    var app = Galileo(reflector: MirrorsReflector())..get('/test/:id', ioc((id) => 'Hello $id'));
    var rq1 = mk(1), rq2 = mk(2), rq3 = mk(1);
    await Future.wait([rq1, rq2, rq3].map(GalileoHttp(app).handleRequest));
    var body1 = await rq1.response.transform(utf8.decoder).join(),
        body2 = await rq2.response.transform(utf8.decoder).join(),
        body3 = await rq3.response.transform(utf8.decoder).join();
    print('Response #1: $body1');
    print('Response #2: $body2');
    print('Response #3: $body3');
    expect(
        body1,
        allOf(
          isNot(body2),
          equals(body3),
        ));
  });
}
