library galileo_orm.generator.models.car;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'car.g.dart';

@serializable
@orm
class _Car extends Model {
  String make;
  String description;
  bool familyFriendly;
  DateTime recalledAt;
}
