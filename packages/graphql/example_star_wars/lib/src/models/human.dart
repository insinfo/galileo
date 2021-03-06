import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:collection/collection.dart';
import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
import 'character.dart';
import 'episode.dart';
part 'human.g.dart';

@serializable
@graphQLClass
abstract class _Human extends Model implements Character {
  // @GraphQLDocumentation(description: "This human's name, of course.")
  // String name;
  // List<Character> friends;
  // List<Episode> appearsIn;
  // List<Starship> starships;
  // int totalCredits;

  String get id;

  String get name;

  List<Episode> get appearsIn;

  List<Character> get friends;

  int get totalCredits;

  // Human(
  //     {this.name,
  //     this.friends,
  //     this.appearsIn,
  //     this.starships,
  //     this.totalCredits});
}
