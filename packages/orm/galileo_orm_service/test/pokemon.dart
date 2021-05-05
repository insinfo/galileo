import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:galileo_orm/galileo_orm.dart';
part 'pokemon.g.dart';

enum PokemonType { fire, grass, water, dragon, poison, dark, fighting, electric, ghost }

@serializable
@orm
abstract class _Pokemon extends Model {
  @notNull
  String get species;

  String get name;

  @notNull
  int get level;

  @notNull
  PokemonType get type1;

  PokemonType get type2;
}
