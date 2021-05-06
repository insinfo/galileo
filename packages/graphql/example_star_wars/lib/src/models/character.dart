import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
import 'episode.dart';
part 'character.g.dart';

@graphQLClass
abstract class Character {
  String get id;

  String get name;

  // List<Episode> get appearsIn;
}
