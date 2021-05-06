import 'package:galileo_migration/galileo_migration.dart';

class FooMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('foo', (table) {
      table
        ..serial('id').primaryKey()
        ..varchar('bar').unique()
        ..date('created_at')
        ..date('updated_at');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('foo');
  }
}
