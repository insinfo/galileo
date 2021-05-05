library galileo_orm_generator.test.models.leg;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'leg.g.dart';

@serializable
@orm
class _Leg extends Model {
  @hasOne
  _Foot foot;

  String name;
}

@serializable
@Orm(tableName: 'feet')
class _Foot extends Model {
  int legId;

  double nToes;
}
