import 'dart:async';

import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_websocket/base_websocket_client.dart';
import 'package:galileo_websocket/server.dart';
import 'package:test/test.dart';

class Todo extends Model {
  String text;
  String when;

  Todo({String this.text, String this.when});
}

class TodoService extends MapService {
  TodoService() : super() {
    configuration['ws:filter'] = (HookedServiceEvent e, WebSocketContext socket) {
      print('Hello, service filter world!');
      return true;
    };
  }
}

testIndex(BaseWebSocketClient client) async {
  var todoService = client.service('api/todos');
  scheduleMicrotask(() => todoService.index());

  var indexed = await todoService.onIndexed.first;
  print('indexed: $indexed');

  expect(indexed, isList);
  expect(indexed, isEmpty);
}
