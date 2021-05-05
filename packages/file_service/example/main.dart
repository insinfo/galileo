import 'package:galileo_file_service/galileo_file_service.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:file/local.dart';

configureServer(Galileo app) async {
  // Just like a normal service
  app.use(
    '/api/todos',
    new JsonFileService(const LocalFileSystem().file('todos_db.json')),
  );
}
