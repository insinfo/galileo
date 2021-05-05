library galileo_orm_generator.test.models.order;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'order.g.dart';

@orm
@serializable
abstract class _Order extends Model {
  @belongsTo
  _Customer get customer;

  int get employeeId;

  DateTime get orderDate;

  int get shipperId;
}

@orm
@serializable
class _Customer extends Model {}
