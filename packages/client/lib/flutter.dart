/// Flutter-compatible client library for the Galileo framework.
library galileo_client.flutter;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'base_galileo_client.dart';
export 'galileo_client.dart';

/// Queries an Galileo server via REST.
class Rest extends BaseGalileoClient {
  Rest(String basePath) : super(http.Client() as http.BaseClient, basePath);

  @override
  Stream<String> authenticateViaPopup(String url, {String eventName = 'token'}) {
    throw UnimplementedError('Opening popup windows is not supported in the `flutter` client.');
  }
}
