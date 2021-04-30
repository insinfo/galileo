import 'dart:io';

import 'package:galileo_sqljocky5/sqljocky.dart';

main() async {
  var s = ConnectionSettings(
    user: "dart_jaguar",
    password: "dart_jaguar",
    host: "localhost",
    port: 3306,
    db: "example",
  );

  var conn = await MySqlConnection.connect(s);

  var r = await conn.execute("CREATE TABLE IF NOT EXISTS t1 (a INT)");
  print(r);
  Results ir = await conn.prepared("INSERT INTO t1 (a) VALUES (?)", [5]).then(deStream);
  print(ir.affectedRows);
  Results sr = await conn.execute("SELECT * FROM t1").deStream();
  print(sr.length);
  exit(0);
}
