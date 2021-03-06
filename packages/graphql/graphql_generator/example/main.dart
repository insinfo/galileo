import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
part 'main.g.dart';

@graphQLClass
class TodoItem {
  String text;

  @GraphQLDocumentation(description: 'Whether this item is complete.')
  bool isComplete;
}

void main() {
  print(todoItemGraphQLType.fields.map((f) => f.name));
}
