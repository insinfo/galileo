import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_migration_runner/galileo_migration_runner.dart';
import 'package:galileo_migration_runner/postgres.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_postgres/galileo_postgres.dart';
import '../../galileo_migration/example/todo.dart';

var migrationRunner = new PostgresMigrationRunner(
  new PostgreSQLConnection('127.0.0.1', 5432, 'test', username: 'postgres', password: 'postgres'),
  migrations: [
    new UserMigration(),
    new TodoMigration(),
    new FooMigration(),
  ],
);

main(List<String> args) => runMigrations(migrationRunner, args);

class FooMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('foos', (table) {
      table
        ..serial('id').primaryKey()
        ..varChar('bar', length: 64)
        ..timeStamp('created_at').defaultsTo(currentTimestamp);
    });
  }

  @override
  void down(Schema schema) => schema.drop('foos');
}
