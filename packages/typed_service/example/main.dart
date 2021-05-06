import 'dart:io';
import 'package:galileo_file_service/galileo_file_service.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_typed_service/galileo_typed_service.dart';
import 'package:file/local.dart';
import 'package:galileo_json_god/galileo_json_god.dart' as god;
import 'package:logging/logging.dart';

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);
  var fs = LocalFileSystem();
  var exampleDir = fs.file(Platform.script).parent;
  var dataJson = exampleDir.childFile('data.json');
  var service = TypedService<String, Todo>(JsonFileService(dataJson));
  hierarchicalLoggingEnabled = true;
  app.use('/api/todos', service);

  app
    ..serializer = god.serialize
    ..logger = Logger.detached('typed_service')
    ..logger.onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}

class Todo extends Model {
  String text;
  bool completed;

  @override
  DateTime createdAt, updatedAt;

  Todo({String id, this.text, this.completed, this.createdAt, this.updatedAt}) : super(id: id);
}
