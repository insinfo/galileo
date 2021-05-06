# galileo_graphql_parser
[![Pub](https://img.shields.io/pub/v/galileo_graphql_parser.svg)](https://pub.dartlang.org/packages/galileo_graphql_parser)
[![build status](https://travis-ci.org/galileo-dart/graphql.svg)](https://travis-ci.org/insinfo/galileo/graphql)

Parses GraphQL queries and schemas.

*This library is merely a parser/visitor*. Any sort of actual GraphQL API functionality must be implemented by you,
or by a third-party package.

[Galileo framework](https://galileodart.com)
users should consider 
[`package:galileo_graphql`](https://pub.dartlang.org/packages/galileo_graphql)
as a dead-simple way to add GraphQL functionality to their servers.

# Installation
Add `galileo_graphql_parser` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  galileo_graphql_parser: ^3.0.0
```

# Usage
The AST featured in this library was originally directly based off this ANTLR4 grammar created by Joseph T. McBride:
https://github.com/antlr/grammars-v4/blob/master/graphql/GraphQL.g4

It has since been updated to reflect upon the grammar in the official GraphQL
specification (
[June 2018](https://facebook.github.io/graphql/June2018/)).

```dart
import 'package:galileo_graphql_parser/galileo_graphql_parser.dart';

doSomething(String text) {
  var tokens = scan(text);
  var parser = Parser(tokens);
  
  if (parser.errors.isNotEmpty) {
    // Handle errors...
  }
  
  // Parse the GraphQL document using recursive descent
  var doc = parser.parseDocument();
  
  // Do something with the parsed GraphQL document...
}
```
