import 'dart:async';
import 'dart:convert';
import 'package:angel_framework/angel_framework.dart';
import 'package:body_parser/body_parser.dart';
import 'package:http/src/base_client.dart' as http;
import 'package:http/src/multipart_file.dart' as http;
import 'package:http/src/multipart_request.dart' as http;
import 'package:http/src/response.dart' as http;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Scans incoming files using VirusTotal's API.
///
/// An error is thrown if the minimum number of positives (default: `3`) is found in the scan report.
///
/// Scans will be checked regularly based on the [checkInterval].
class VirusTotalScanner {
  final String apiKey;
  final http.BaseClient client;
  int minPositives;
  Duration checkInterval;
  String endpoint;

  VirusTotalScanner(this.apiKey, this.client,
      {this.checkInterval, this.endpoint, this.minPositives}) {
    this.checkInterval ??= const Duration(seconds: 5);
    this.endpoint ??= 'https://www.virustotal.com/vtapi/v2';
    this.minPositives ??= 3;
  }

  /// Virus-scans all files uploaded within this request.
  Future<bool> handleRequest(RequestContext req, ResponseContext res) async {
    for (var file in await req.lazyFiles()) {
      if (await scanFile(file))
        throw new AngelHttpException.badRequest(
            message: 'Malicious upload blocked.');
    }

    return true;
  }

  /// Queries VirusTotal, and returns `true` if a file is malicious in nature.
  Future<bool> scanFile(FileUploadInfo file) async {
    var rq =
        new http.MultipartRequest('POST', Uri.parse('$endpoint/file/scan'));

    rq.headers.addAll({
      'accept': 'application/json',
      'accept-encoding': 'gzip',
    });

    // Add API key
    rq.fields['apikey'] = apiKey;

    // Add actual file
    rq.files.add(new http.MultipartFile(
      'file',
      new Stream<List<int>>.fromIterable([file.data]),
      file.data.length,
      filename: file.filename,
      contentType: new MediaType.parse(file.mimeType),
    ));

    var rs =
        await client.send(rq).then<http.Response>(http.Response.fromStream);

    if (new MediaType.parse(rs.headers['content-type']).mimeType !=
        'application/json') {
      throw new StateError(
          'VirusTotal did not response with JSON (status: ${rs.statusCode}). Response: "${rs.body}"');
    }

    var json = JSON.decode(rs.body);
    var scanId = json['scan_id'];

    if (scanId == null)
      throw new StateError(
          'VirusTotal did not send the ID of a scan report. Did you provide an API key?');

    var c = new Completer<bool>();

    callback(_) async {
      var rs = await client.post('$endpoint/url/report', headers: {
        'accept': 'application/json',
        'accept-encoding': 'gzip',
      }, body: {
        'apikey': apiKey,
        'resource': scanId,
      });

      if (new MediaType.parse(rs.headers['content-type']).mimeType !=
          'application/json') {
        throw new StateError(
            'VirusTotal did not response with JSON (status: ${rs.statusCode}). Response: "${rs.body}"');
      }

      var json = JSON.decode(rs.body);

      if (json['positives'] is int) {
        int positives = json['positives'];

        if (positives >= 1 && !c.isCompleted)
          c.complete(true);
        else if (!c.isCompleted) c.complete(false);
      }
    }

    await callback(null);

    if (!c.isCompleted) new Timer.periodic(checkInterval, callback);

    return await c.future;
  }
}
