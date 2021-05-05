import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_orm_service/galileo_orm_service.dart';
import 'package:logging/logging.dart';
import 'connect.dart';
import 'todo.dart';

main() async {
  // Logging, connection setup.
  hierarchicalLoggingEnabled = true;
  var app = Galileo(logger: Logger.detached('orm_service'));
  var http = GalileoHttp(app);
  var executor = await connect();
  app.logger.onRecord.listen((rec) {
    print(rec);
    if (rec.error != null) print(rec.error);
    if (rec.stackTrace != null) print(rec.stackTrace);
  });

  // Create an ORM-backed service.
  var todoService = OrmService<int, Todo, TodoQuery>(executor, () => TodoQuery(),
      readData: (req, res) => todoSerializer.decode(req.bodyAsMap));

  // Because we provided `readData`, the todoService can face the Web.
  // **IMPORTANT: Providing the type arguments is an ABSOLUTE MUST, if your
  // model has `int` ID's (this is the case when using `galileo_orm_generator` and `Model`).
  // **
  app.use<int, Todo, OrmService<int, Todo, TodoQuery>>('/api/todos', todoService);

  // Clean up when we are done.
  app.shutdownHooks.add((_) => executor.close());

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
  print('Todos API: ${http.uri}/api/todos');
}
