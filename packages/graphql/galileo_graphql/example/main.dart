// ignore_for_file: deprecated_member_use
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_graphql/galileo_graphql.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
import 'package:galileo_graphql_schema/galileo_graphql_schema.dart';
import 'package:galileo_graphql_server/galileo_graphql_server.dart';
import 'package:galileo_graphql_server/mirrors.dart';
import 'package:logging/logging.dart';

main() async {
  var logger = Logger('galileo_graphql');
  var app = Galileo(
      logger: logger
        ..onRecord.listen((rec) {
          print(rec);
          if (rec.error != null) print(rec.error);
          if (rec.stackTrace != null) print(rec.stackTrace);
        }));
  var http = GalileoHttp(app);

  var todoService = app.use('api/todos', MapService());

  var queryType = objectType(
    'Query',
    description: 'A simple API that manages your to-do list.',
    fields: [
      field(
        'todos',
        listOf(convertDartType(Todo).nonNullable()),
        resolve: resolveViaServiceIndex(todoService),
      ),
      field(
        'todo',
        convertDartType(Todo),
        resolve: resolveViaServiceRead(todoService),
        inputs: [
          GraphQLFieldInput('id', graphQLId.nonNullable()),
        ],
      ),
    ],
  );

  var mutationType = objectType(
    'Mutation',
    description: 'Modify the to-do list.',
    fields: [
      field(
        'createTodo',
        convertDartType(Todo),
        inputs: [
          GraphQLFieldInput('data', convertDartType(Todo).coerceToInputObject()),
        ],
        resolve: resolveViaServiceCreate(todoService),
      ),
    ],
  );

  var schema = graphQLSchema(
    queryType: queryType,
    mutationType: mutationType,
  );

  app.all('/graphql', graphQLHttp(GraphQL(schema)));
  app.get('/graphiql', graphiQL());

  await todoService.create({'text': 'Clean your room!', 'completion_status': 'COMPLETE'});
  await todoService.create({'text': 'Take out the trash', 'completion_status': 'INCOMPLETE'});
  await todoService.create({'text': 'Become a billionaire at the age of 5', 'completion_status': 'INCOMPLETE'});

  var server = await http.startServer('127.0.0.1', 3000);
  var uri = Uri(scheme: 'http', host: server.address.address, port: server.port);
  var graphiqlUri = uri.replace(path: 'graphiql');
  print('Listening at $uri');
  print('Access graphiql at $graphiqlUri');
}

@GraphQLDocumentation(description: 'Any object with a .text (String) property.')
abstract class HasText {
  String get text;
}

@serializable
@GraphQLDocumentation(description: 'A task that might not be completed yet. **Yay! Markdown!**')
class Todo extends Model implements HasText {
  String text;

  @GraphQLDocumentation(deprecationReason: 'Use `completion_status` instead.')
  bool completed;

  CompletionStatus completionStatus;

  Todo({this.text, this.completed, this.completionStatus});
}

@GraphQLDocumentation(description: 'The completion status of a to-do item.')
enum CompletionStatus { COMPLETE, INCOMPLETE }
