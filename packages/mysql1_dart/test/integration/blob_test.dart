library galileo_mysql.test.blob_test;

import 'package:galileo_mysql/galileo_mysql.dart';
import 'package:test/test.dart';

import '../test_infrastructure.dart';

const tableName = 'blobtable';

void main() {
  initializeTest(tableName, 'create table $tableName (stuff blob)');

  test('write blob', () async {
    await conn.query('insert into $tableName (stuff) values (?)', [
      [0xc3, 0x28]
    ]); // this is an invalid UTF8 string
    var results = await conn.query('select * from $tableName');
    expect((results.first[0] as Blob).toBytes(), equals([0xc3, 0x28]));
  });
}
