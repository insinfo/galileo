import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'foo.dart';
part 'bar.g.dart';

@serializable
abstract class _Bar extends Model {
  Foo get foo;

  String get description;
}
