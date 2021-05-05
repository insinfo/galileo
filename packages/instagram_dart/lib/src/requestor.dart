import 'dart:async';
import 'package:http/src/base_client.dart' as http;
import 'package:http/src/request.dart' as http;
import 'package:http/src/response.dart' as http;
import 'models/impl_models.dart';

abstract class Requestor {
  Uri buildUri(String path, {Map<String, String> queryParameters, String method});

  Map<String, String> buildBody(Map<String, String> body);

  Future<InstagramResponse> request(String path, {Map<String, String> body, Map<String, String> queryParameters, String method}) {
    var uri = buildUri(path, queryParameters: queryParameters, method: method);
    var rq = new http.Request(method ?? 'GET', uri);
    rq.headers['accept'] = 'application/json';

    if (body?.isNotEmpty == true) {
      // rq.headers['content-type'] = 'application/json';
      rq.bodyFields = buildBody(body);
    }

    return send(rq);
  }

  Future<InstagramResponse> send(http.Request request);
}
