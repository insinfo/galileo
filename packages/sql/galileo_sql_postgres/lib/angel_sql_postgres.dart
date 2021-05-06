import 'dart:async';
import 'package:galileo_sql/galileo_sql.dart';
import 'package:postgres/postgres.dart';

/// An implementation of [SqlService] that queries a PostgreSQL database.
class PostgreSqlService<Id, Data> extends SqlService<Id, Data> {
  final PostgreSQLConnection connection;

  PostgreSqlService(
      this.connection,
      Map<String, dynamic> Function(Data) encoder,
      Data Function(List) decoder,
      String tableName,
      Iterable<String> fields)
      : super(encoder, decoder, tableName, fields);

  @override
  Future<List> row(String fmtString, Map<String, dynamic> substitutionValues) {
    return rows(fmtString, substitutionValues).then((list) {
      return list.isEmpty ? null : list.first;
    });
  }

  @override
  Future<List<List>> rows(
      String fmtString, Map<String, dynamic> substitutionValues) {
    return connection.query(fmtString, substitutionValues: substitutionValues);
  }
}
