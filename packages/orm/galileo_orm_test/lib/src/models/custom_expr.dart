import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'custom_expr.g.dart';

@serializable
@orm
class _Numbers extends Model {
  @Column(expression: 'SELECT 2')
  int two;
}

@serializable
@orm
class _Alphabet extends Model {
  String value;

  @belongsTo
  _Numbers numbers;
}
