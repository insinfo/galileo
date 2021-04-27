import 'dart:io' show HttpDate;
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/local.dart';
import 'package:http/http.dart' show Client;
import 'package:logging/logging.dart';
import 'package:matcher/matcher.dart';
import 'package:test/test.dart';

void main() {
  Galileo app;
  GalileoHttp http;
  var testDir = const LocalFileSystem().directory('test');
  String url;
  var client = Client();

  setUp(() async {
    app = Galileo();
    http = GalileoHttp(app);

    app.fallback(
      CachingVirtualDirectory(app, const LocalFileSystem(), source: testDir, maxAge: 350, onlyInProduction: false,
          //publicPath: '/virtual',
          indexFileNames: ['index.txt']).handleRequest,
    );

    app.get('*', (req, res) => 'Fallback');

    app.dumpTree(showMatchers: true);

    app.logger = Logger('galileo_static')
      ..onRecord.listen((rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      });

    var server = await http.startServer();
    url = 'http://${server.address.host}:${server.port}';
  });

  tearDown(() async {
    if (http.server != null) await http.server.close(force: true);
  });

  test('sets etag, cache-control, expires, last-modified', () async {
    var response = await client.get(Uri.parse('$url'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print('Response headers: ${response.headers}');

    expect(response.statusCode, equals(200));
    expect(['etag', 'cache-control', 'expires', 'last-modified'],
        everyElement(predicate(response.headers.containsKey, 'contained in response headers')));
  });

  test('if-modified-since', () async {
    var response = await client.get(Uri.parse('$url'),
        headers: {'if-modified-since': HttpDate.format(DateTime.now().add(Duration(days: 365)))});

    print('Response status: ${response.statusCode}');

    expect(response.statusCode, equals(304));
    expect(['cache-control', 'expires', 'last-modified'],
        everyElement(predicate(response.headers.containsKey, 'contained in response headers')));
  });
}
