import 'package:galileo_file_security/galileo_file_security.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:http/src/multipart_file.dart' as http;
import 'package:http/src/multipart_request.dart' as http;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:test/test.dart';

main() {
  Galileo app;
  http.Client client;
  Uri uploadEndpoint;
  GalileoHttp server;

  setUp(() async {
    app = new Galileo();
    server = GalileoHttp(app);

    app.chain([
      FileSecurityMiddleware(
        maxFiles: 1,
        maxFileSize: 1000,
        allowedExtensions: ['.txt'],
        allowedContentTypes: ['text/plain'],
      ).handleRequest
    ]).post('/upload', (req, resp) => 'OK');

    client = new http.Client();

    await server.startServer();
    uploadEndpoint = server.uri;
  });

  tearDown(() async {
    await app.close();
    client.close();
  });

  test('max number of files', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromBytes('file1', new List<int>.filled(20, 0)),
      new http.MultipartFile.fromBytes('file2', new List<int>.filled(20, 0)),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 413);
  });

  test('max file size', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromBytes('file', new List<int>.filled(2000, 0)),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 413);
  });

  test('extensions enforced', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromString('file', 'hello', filename: 'world.exe'),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 400);
  });

  test('mime types enforced', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromString(
        'file',
        'hello',
        contentType: new MediaType.parse('foo/bar'),
      ),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 400);
  });

  test('acceptable file', () async {
    var rq = new http.MultipartRequest('POST', uploadEndpoint);
    rq.files.addAll([
      new http.MultipartFile.fromString(
        'file1',
        'hello',
        filename: 'world.txt',
        contentType: new MediaType.parse('text/plain'),
      ),
    ]);
    var response = await client.send(rq);
    expect(response.statusCode, 200);
  });
}
