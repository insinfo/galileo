import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
import 'package:test/test.dart';

final Matcher throwsAGraphQLException = throwsA(predicate((x) => x is GraphQLException, 'is a GraphQL exception'));
