import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'email_indexed.g.dart';

// * https://github.com/galileo-dart/galileo/issues/116

@serializable
@orm
abstract class _Role {
  @PrimaryKey(columnType: ColumnType.varChar)
  String get role;

  @ManyToMany(_RoleUser)
  List<_User> get users;
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
abstract class _User {
  // @PrimaryKey(columnType: ColumnType.varChar)
  @primaryKey
  String get email;
  String get name;
  String get password;

  @ManyToMany(_RoleUser)
  List<_Role> get roles;
}
