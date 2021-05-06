import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_mongo/galileo_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';

main() async {
  var app = new Galileo();
  Db db = new Db('mongodb://localhost:27017/local');
  await db.open();

  var service = app.use('/api/users', new MongoService(db.collection("users")));

  service.afterCreated.listen((event) {
    print("New user: ${event.result}");
  });
}
