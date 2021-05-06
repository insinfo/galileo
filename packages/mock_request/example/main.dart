import 'dart:async';
import 'package:galileo_mock_request/galileo_mock_request.dart';

Future<void> main() async {
  var rq = MockHttpRequest('GET', Uri.parse('/foo'));
  await rq.close();
}
