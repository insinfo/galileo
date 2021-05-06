import 'package:galileo_client/galileo_client.dart' as c;
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_rethink/galileo_rethink.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:logging/logging.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:test/test.dart';
import 'common.dart';

main() {
  Galileo app;
  TestClient client;
  Rethinkdb r;
  c.Service todoService;

  setUp(() async {
    r = Rethinkdb();
    var conn = await r.connect();

    app = Galileo();
    app.use('/todos', RethinkService(conn, r.table('todos')));

    app.errorHandler = (e, req, res) async {
      print('Whoops: $e');
    };

    app.logger = Logger.detached('galileo')..onRecord.listen(print);

    client = await connectTo(app);
    todoService = client.service('todos');
  });

  tearDown(() => client.close());

  test('index', () async {
    var result = await todoService.index();
    print('Response: $result');
    expect(result, isList);
  });

  test('create+read', () async {
    var todo = Todo(title: 'Clean your room');
    var creation = await todoService.create(todo.toJson());
    print('Creation: $creation');

    var id = creation['id'];
    var result = await todoService.read(id);

    print('Response: $result');
    expect(result, isMap);
    expect(result['id'], equals(id));
    expect(result['title'], equals(todo.title));
    expect(result['completed'], equals(todo.completed));
  });

  test('modify', () async {
    var todo = Todo(title: 'Clean your room');
    var creation = await todoService.create(todo.toJson());
    print('Creation: $creation');

    var id = creation['id'];
    var result = await todoService.modify(id, {'title': 'Eat healthy'});

    print('Response: $result');
    expect(result, isMap);
    expect(result['id'], equals(id));
    expect(result['title'], equals('Eat healthy'));
    expect(result['completed'], equals(todo.completed));
  });

  test('remove', () async {
    var todo = Todo(title: 'Clean your room');
    var creation = await todoService.create(todo.toJson());
    print('Creation: $creation');

    var id = creation['id'];
    var result = await todoService.remove(id);

    print('Response: $result');
    expect(result, isMap);
    expect(result['id'], equals(id));
    expect(result['title'], equals(todo.title));
    expect(result['completed'], equals(todo.completed));
  });
}
