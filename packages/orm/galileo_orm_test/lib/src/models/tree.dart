library galileo_orm_generator.test.models.tree;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:collection/collection.dart';
part 'tree.g.dart';

@serializable
@orm
class _Tree extends Model {
  @Column(indexType: IndexType.unique, type: ColumnType.smallInt)
  int rings;

  @hasMany
  List<_Fruit> fruits;
}

@serializable
@orm
class _Fruit extends Model {
  int treeId;
  String commonName;
}
