import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'foo.dart';
part 'bar.g.dart';

@serializable
abstract class _Bar extends Model {
  Foo get foo;

  String get description;
}
