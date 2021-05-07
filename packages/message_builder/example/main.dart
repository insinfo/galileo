import 'dart:convert';

import 'messages.dart';

void main() {
  final messageJson =
      jsonDecode('{"intField": 1, "stringField": "hello"}') as Map;
  final parsedMessage = SomeMessage.fromJson(messageJson);

  final message = SomeMessage((b) => b
    ..intField = 1
    ..stringField = 'hello');

  assert(parsedMessage == message);
}
