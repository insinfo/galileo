import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
part 'starship.g.dart';

@serializable
@graphQLClass
abstract class _Starship extends Model {
  String get name;
  int get length;
}
