import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_sql/angel_sql.dart';
import 'package:angel_sql_postgres/angel_sql_postgres.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';

main() async {
  var app = new Angel();
  var http = new AngelHttp(app);
  var connection = new PostgreSQLConnection(
      InternetAddress.loopbackIPv4.address, 5432, 'angel_sql_example',
      username: 'thosakwe');
  var fields = ['id', 'text', 'completed', 'created_at', 'updated_at'];
  var echo = new PostgreSqlService<String, Map<String, dynamic>>(
      connection, (map) => map, parseRowFromFields(fields), 'todos', fields);
  app.use('/api/todos', echo);

  await connection.open();
  app.shutdownHooks.add((_) => connection.close());

  app.logger = new Logger('angel_sql_postgres')..onRecord.listen((rec) {
    print(rec);
    if (rec.error != null) print(rec.error);
    if (rec.stackTrace != null) print(rec.stackTrace);
  });

  await http.startServer(InternetAddress.loopbackIPv4, 3000);
  print('Listening at ${http.uri}');
}
