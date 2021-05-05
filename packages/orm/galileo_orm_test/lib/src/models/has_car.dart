import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
// import 'car.dart';
part 'has_car.g.dart';

// Map _carToMap(Car car) => car.toJson();

// Car _carFromMap(map) => CarSerializer.fromMap(map as Map);

enum CarType { sedan, suv, atv }

@orm
@serializable
abstract class _HasCar extends Model {
  // TODO: Do this without explicit serializers
  // @SerializableField(
  //     serializesTo: Map, serializer: #_carToMap, deserializer: #_carFromMap)
  // Car get car;

  @SerializableField(isNullable: false, defaultValue: CarType.sedan)
  CarType get type;
}
