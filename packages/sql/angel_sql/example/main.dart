import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_sql/angel_sql.dart';

main() async {
  var app = new Angel();
  var http = new AngelHttp(app);
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
