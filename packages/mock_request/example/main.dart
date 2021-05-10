import 'dart:async';
import 'package:galileo_mock_request/galileo_mock_request.dart';

Future<void> main() async {
  var rq = MockHttpRequest('GET', Uri.parse('/foo'));
  print(rq.response.statusCode);
  await rq.close();
}
