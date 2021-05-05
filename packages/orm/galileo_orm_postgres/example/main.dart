import 'dart:io';
import 'package:galileo_orm_postgres/galileo_orm_postgres.dart';
import 'package:galileo_postgres/galileo_postgres.dart';

main() async {
  var executor = new PostgreSqlExecutorPool(Platform.numberOfProcessors, () {
    return new PostgreSQLConnection('localhost', 5432, 'galileo_orm_test');
  });

  var rows = await executor.query('users', 'SELECT * FROM users', {});
  print(rows);
}
