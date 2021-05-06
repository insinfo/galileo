library galileo.src.models.user;

import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:galileo_orm/galileo_orm.dart';
part 'user.g.dart';

@serializable
@orm
class _User extends Model {
  String email, name;
}
