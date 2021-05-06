import 'dart:async';
import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_sql/galileo_sql.dart';

main() async {
  var app = new Galileo();
  var http = new GalileoHttp(app);
  var echo = new _SqlEchoService(
      'todos', ['id', 'text', 'completed', 'created_at', 'updated_at']);

  app.use('/api/todos', echo);

  await http.startServer(InternetAddress.loopbackIPv4, 3000);
  print('Listening at ${http.uri}');
}

class _SqlEchoService extends SqlService<String, Map<String, dynamic>> {
  _SqlEchoService(String tableName, Iterable<String> fields)
      : super(
            (data) => data,
            (row) => {'query': row[0], 'substitution_values': row[1]},
            tableName,
            fields);

  @override
  FutureOr<List> row(String query, Map<String, dynamic> substitutionValues) {
    return [query, substitutionValues];
  }

  @override
  FutureOr<List<List>> rows(
      String query, Map<String, dynamic> substitutionValues) {
    return [row(query, substitutionValues)];
  }
}
