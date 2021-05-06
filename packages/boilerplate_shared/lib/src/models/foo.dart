import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'foo.g.dart';

@serializable
abstract class _Foo extends Model {
  String get text;

  @nullable
  int get number;
}
