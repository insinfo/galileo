import 'dart:io';
import 'package:galileo_file_security/galileo_file_security.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:http/src/multipart_file.dart' as http;
import 'package:http/src/multipart_request.dart' as http;
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:test/test.dart';
import '../lib/src/virus_total.dart';
import 'mock_virus_total.dart' as mock_virus_total;

main() {
  Galileo app;
  GalileoHttp mockServer;
  http.Client client;
  Uri uploadEndpoint;
  GalileoHttp server;

  setUp(() async {
    app = new Galileo();
    server = GalileoHttp(app);

    var mock = new Galileo();
    await mock.configure(mock_virus_total.configureServer);
    await mockServer.startServer();

    var virusScanner = new VirusTotalScanner(
      'foo',
      new http.Client(),
      endpoint: mockServer.uri.toString(),
      checkInterval: const Duration(seconds: 1),
    );

    print('Mock virus total: ${virusScanner.endpoint}');

    app.chain([
      virusScanner.handleRequest,
    ]).post('/upload', (req, rep) => 'OK');

    //app.use(() => throw new GalileoHttpException.notFound());

    app.shutdownHooks.add((_) async {
      virusScanner.client.close();
    });

    app.logger = new Logger('galileo');

    Logger.root.onRecord.listen(
      (rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      },
    );

    client = new http.Client();

    await server.startServer();
    uploadEndpoint = server.uri;
    print('virus_scan_test listening at $uploadEndpoint');
  });

  tearDown(() async {
    await mockServer.close();
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
