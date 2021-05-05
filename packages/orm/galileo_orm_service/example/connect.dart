import 'dart:async';
import 'dart:io';
import 'package:galileo_orm_postgres/galileo_orm_postgres.dart';
import 'package:galileo_postgres/galileo_postgres.dart';

final conn = PostgreSQLConnection('localhost', 5432, 'galileo_orm_service_test',
    username: Platform.environment['POSTGRES_USERNAME'] ?? 'postgres',
    password: Platform.environment['POSTGRES_PASSWORD'] ?? 'password');

Future<PostgreSqlExecutor> connect() async {
  var executor = PostgreSqlExecutor(conn);
  await conn.open();
  return executor;
}
