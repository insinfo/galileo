import 'dart:async';
import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_orm/src/query.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'main.g.dart';

main() async {
  var query = EmployeeQuery()
    ..where.firstName.equals('Rich')
    ..where.lastName.equals('Person')
    ..orWhere((w) => w.salary.greaterThanOrEqualTo(75000))
    ..join('companies', 'company_id', 'id');

  var richPerson = await query.getOne(_FakeExecutor());
  print(richPerson.toJson());
}

class _FakeExecutor extends QueryExecutor {
  const _FakeExecutor();

  @override
  Future<List<List>> query(String tableName, String query, Map<String, dynamic> substitutionValues,
      [returningFields]) async {
    var now = DateTime.now();
    print('_FakeExecutor received query: $query and values: $substitutionValues');
    return [
      [1, 'Rich', 'Person', 100000.0, now, now]
    ];
  }

  @override
  Future<T> transaction<T>(FutureOr<T> Function(QueryExecutor) f) {
    throw UnsupportedError('Transactions are not supported.');
  }
}

@orm
@serializable
abstract class _Employee extends Model {
  String get firstName;

  String get lastName;

  @Column(indexType: IndexType.unique)
  String uniqueId;

  double get salary;
}
