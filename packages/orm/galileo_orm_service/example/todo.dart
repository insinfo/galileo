import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:galileo_orm/galileo_orm.dart';
part 'todo.g.dart';

@serializable
@orm
abstract class _Todo extends Model {
  @notNull
  String get text;

  @DefaultsTo(false)
  bool isComplete;
}
