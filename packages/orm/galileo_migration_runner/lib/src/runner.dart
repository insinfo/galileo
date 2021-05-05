import 'dart:async';
import 'package:galileo_migration/galileo_migration.dart';

abstract class MigrationRunner {
  void addMigration(Migration migration);

  Future up();

  Future rollback();

  Future reset();

  Future close();
}
