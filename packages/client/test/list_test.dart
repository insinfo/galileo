import 'package:async/async.dart';
import 'dart:io';
import 'package:galileo_client/io.dart' as c;

import 'package:galileo_framework/galileo_framework.dart' as s;
import 'package:galileo_framework/http.dart' as s;
import 'package:pedantic/pedantic.dart';
import 'package:test/test.dart';
import 'package:galileo_container/mirrors.dart' as di;

main() {
  HttpServer server;
  c.Galileo app;
  c.ServiceList list;
  StreamQueue queue;

  setUp(() async {
    var serverApp = s.Galileo(reflector: di.MirrorsReflector());
    var http = s.GalileoHttp(serverApp);
    serverApp.use('/api/todos', s.MapService(autoIdAndDateFields: false));

    server = await http.startServer();
    var uri = 'http://${server.address.address}:${server.port}';
    app = c.Rest(uri);
    list = c.ServiceList(app.service('api/todos'));
    queue = StreamQueue(list.onChange);
  });

  tearDown(() async {
    await server.close(force: true);
    unawaited(list.close());
    unawaited(list.service.close());
    unawaited(app.close());
  });

  test('listens on create', () async {
    unawaited(list.service.create({'foo': 'bar'}));
    await list.onChange.first;
    expect(list, [
      {'foo': 'bar'}
    ]);
  });

  test('listens on modify', () async {
    unawaited(list.service.create({'id': 1, 'foo': 'bar'}));
    await queue.next;

    await list.service.update(1, {'id': 1, 'bar': 'baz'});
    await queue.next;
    expect(list, [
      {'id': 1, 'bar': 'baz'}
    ]);
  });

  test('listens on remove', () async {
    unawaited(list.service.create({'id': '1', 'foo': 'bar'}));
    await queue.next;

    await list.service.remove('1');
    await queue.next;
    expect(list, isEmpty);
  });
}
