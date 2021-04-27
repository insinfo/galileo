import 'dart:async';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_mock_request/galileo_mock_request.dart';
import 'package:test/test.dart';

final Uri ENDPOINT = Uri.parse('http://example.com');

main() {
  test('single extension', () async {
    var req = await makeRequest('foo.js');
    expect(req.extension, '.js');
  });

  test('multiple extensions', () async {
    var req = await makeRequest('foo.min.js');
    expect(req.extension, '.js');
  });

  test('no extension', () async {
    var req = await makeRequest('foo');
    expect(req.extension, '');
  });
}

Future<RequestContext> makeRequest(String path) {
  var rq = MockHttpRequest('GET', ENDPOINT.replace(path: path))..close();
  var app = Galileo(reflector: MirrorsReflector());
  var http = GalileoHttp(app);
  return http.createRequestContext(rq, rq.response);
}
