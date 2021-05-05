import 'dart:async';
import 'dart:io';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_orm_mysql/galileo_orm_mysql.dart';
import 'package:logging/logging.dart';
import 'package:galileo_sqljocky5/sqljocky.dart';

FutureOr<QueryExecutor> Function() my(Iterable<String> schemas) {
  return () => connectToMySql(schemas);
}

Future<void> closeMy(QueryExecutor executor) => (executor as MySqlExecutor).close();

Future<MySqlExecutor> connectToMySql(Iterable<String> schemas) async {
  var settings = ConnectionSettings(
      db: 'galileo_orm_test',
      user: Platform.environment['MYSQL_USERNAME'] ?? 'galileo_orm_test',
      password: Platform.environment['MYSQL_PASSWORD'] ?? 'galileo_orm_test');
  var connection = await MySqlConnection.connect(settings);
  var logger = Logger('galileo_orm_mysql');

  for (var s in schemas) await connection.execute(await new File('test/migrations/$s.sql').readAsString());

  return MySqlExecutor(connection, logger: logger);
}
