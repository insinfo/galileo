import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_sembast/galileo_sembast.dart';
import 'package:logging/logging.dart';
import 'package:sembast/sembast_io.dart';

main() async {
  var app = Galileo();
  var db = await databaseFactoryIo.openDatabase('todos.db');

  app
    ..logger = (Logger('galileo_sembast_example')..onRecord.listen(print))
    ..use('/api/todos', SembastService(db, store: 'todos'))
    ..shutdownHooks.add((_) => db.close());

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  var uri =
      Uri(scheme: 'http', host: server.address.address, port: server.port);
  print('galileo_sembast example listening at $uri');
}
