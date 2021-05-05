library galileo_orm_generator.test.models.user;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:collection/collection.dart';
part 'user.g.dart';

@serializable
@orm
abstract class _User extends Model {
  String get username;
  String get password;
  String get email;

  @ManyToMany(_RoleUser)
  List<_Role> get roles;
}

@serializable
@orm
abstract class _RoleUser {
  @belongsTo
  _Role get role;

  @belongsTo
  _User get user;
}

@serializable
@orm
abstract class _Role extends Model {
  String name;

  @ManyToMany(_RoleUser)
  List<_User> get users;
}
