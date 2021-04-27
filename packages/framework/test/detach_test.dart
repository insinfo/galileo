import 'dart:convert';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_mock_request/galileo_mock_request.dart';
import 'package:test/test.dart';

void main() {
  GalileoHttp http;

  setUp(() async {
    var app = Galileo();
    http = GalileoHttp(app);

    app.get('/detach', (req, res) async {
      if (res is HttpResponseContext) {
        var io = await res.detach();
        io..write('Hey!');
        await io.close();
      } else {
        throw StateError('This endpoint only supports HTTP/1.1.');
      }
    });
  });

  tearDown(() => http.close());

  test('detach response', () async {
    var rq = MockHttpRequest('GET', Uri.parse('/detach'));
    await rq.close();
    var rs = rq.response;
    await http.handleRequest(rq);
    var body = await rs.transform(utf8.decoder).join();
    expect(body, 'Hey!');
  });
}
