import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
part 'episode.g.dart';

@GraphQLDocumentation(description: 'The episodes of the Star Wars original trilogy.')
@graphQLClass
enum Episode {
  NEWHOPE,
  EMPIRE,
  JEDI,
}
