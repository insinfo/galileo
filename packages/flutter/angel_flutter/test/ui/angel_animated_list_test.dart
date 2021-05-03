// import 'dart:async';
// import 'dart:convert';
// import 'package:angel_client/base_angel_client.dart';
// import 'package:angel_flutter/ui/angel_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:http_mock/http_mock.dart';

// void main() {
//   var server = new MockClient();
//   var app = new _Rest(server);
//   var todos = <Map>[];

//   server.router.group('api/todos', (router) {
//     router
//       ..get('/', (_) => todos)
//       ..post('/', (MockHttpContext ctx) async {
//         var todo = await ctx.request.body
//             .transform(UTF8.decoder)
//             .join()
//             .then(JSON.decode);
//         todos.add(todo);
//         return todo;
//       });
//   });

//   testWidgets('empty state', (WidgetTester tester) async {
//     var key = new GlobalKey();
//     var service = app.service('api/todos');

//     await tester.pumpWidget(
//       new AngelAnimatedList(
//         service: service,
//         builder: null,
//         emptyState: (context) {
//           return new Center(
//             key: key,
//             child: const CircularProgressIndicator(),
//           );
//         },
//       ),
//     );

//     await service.index();
//     expect(key.currentWidget, isNotNull);
//   });
// }

// class _Rest extends BaseAngelClient {
//   final MockClient client;

//   _Rest(this.client) : super(client, '');

//   @override
//   Stream<String> authenticateViaPopup(String url, {String eventName: 'token'}) {
//     throw new UnsupportedError('nope');
//   }
// }
