import 'package:galileo_migration_runner/galileo_migration_runner.dart';
import 'package:galileo_migration_runner/postgres.dart';
import 'connect.dart';
import 'todo.dart';

main(List<String> args) {
  var runner = PostgresMigrationRunner(conn, migrations: [
    TodoMigration(),
  ]);
  return runMigrations(runner, args);
}
