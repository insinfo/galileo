import 'dart:io';
import 'package:angel_file_security/angel_file_security.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:http/src/multipart_file.dart' as http;
import 'package:http/src/multipart_request.dart' as http;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import 'mock_virus_total.dart' as mock_virus_total;

main() {
  Angel app;
  HttpServer mockServer;
  http.Client client;
  Uri uploadEndpoint;

  setUp(() async {
    app = new Angel()..lazyParseBodies = true;

    var mock = new Angel();
    await mock.configure(mock_virus_total.configureServer);
    mockServer = await mock.startServer();

    var virusScanner = new VirusTotalScanner(
      'foo',
      new http.Client(),
      endpoint: 'http://${mockServer.address.address}:${mockServer.port}',
      checkInterval: const Duration(seconds: 1),
    );

    print('Mock virus total: ${virusScanner.endpoint}');

    app.post('/upload', waterfall([
      virusScanner.handleRequest,
      'OK',
    ]));

    app.use(() => throw new AngelHttpException.notFound());

    app.shutdownHooks.add((_) async {
      virusScanner.client.close();
    });

    app.logger = new Logger('angel');

    Logger.root.onRecord.listen(
      (rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      },
    );

    client = new http.Client();

    var server = await app.startServer();
    uploadEndpoint =
        Uri.parse('http://${server.address.address}:${server.port}/upload');
    print('virus_scan_test listening at $uploadEndpoint');
  });

  tearDown(() async {
    await mockServer.close(force: true);
    await app.close();
    client.close();
  });

  test('blocks viruses', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromBytes('file', new List<int>.filled(20, 0)),
      new http.MultipartFile.fromBytes(
        'file2',
        new List<int>.filled(20, 0),
        filename: 'evil.virus',
      ),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 400);
  });

  test('lets clean files through', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromBytes('file1', new List<int>.filled(20, 0)),
      new http.MultipartFile.fromBytes('file2', new List<int>.filled(20, 0)),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 200);
  });
}
