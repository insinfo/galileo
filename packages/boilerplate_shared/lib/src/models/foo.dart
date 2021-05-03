import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'foo.g.dart';

@serializable
abstract class _Foo extends Model {
  String get text;

  @nullable
  int get number;
}
