import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_orm_mysql/galileo_orm_mysql.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:logging/logging.dart';
import 'package:galileo_sqljocky5/sqljocky.dart';
part 'main.g.dart';

main() async {
  hierarchicalLoggingEnabled = true;
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(print);

  var settings = ConnectionSettings(db: 'galileo_orm_test', user: 'galileo_orm_test', password: 'galileo_orm_test');
  var connection = await MySqlConnection.connect(settings);
  var logger = Logger('galileo_orm_mysql');
  var executor = MySqlExecutor(connection, logger: logger);

  var query = TodoQuery();
  query.values
    ..text = 'Clean your room!'
    ..isComplete = false;

  var todo = await query.insert(executor);
  print(todo.toJson());

  var query2 = TodoQuery()..where.id.equals(todo.idAsInt);
  var todo2 = await query2.getOne(executor);
  print(todo2.toJson());
  print(todo == todo2);
}

@serializable
@orm
abstract class _Todo extends Model {
  String get text;

  @DefaultsTo(false)
  bool isComplete;
}
