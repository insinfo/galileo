import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_orm_test/src/models/car.dart';

@Expose('/api/cars')
class CarController extends Controller {
  @Expose('/luxury')
  Future<List<Car>> getLuxuryCars(QueryExecutor connection) {
    var query = new CarQuery();
    query.where
      ..familyFriendly.equals(false)
      ..createdAt.year.greaterThanOrEqualTo(2014)
      ..make.isIn(['Ferrari', 'Lamborghini', 'Mustang', 'Lexus']);
    return query.get(connection);
  }
}
