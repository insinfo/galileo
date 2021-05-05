![Logo](https://github.com/galileo-dart/graphql/raw/master/img/galileo_logo.png)

<div style="text-align: center">
<hr>
<a href="https://pub.dartlang.org/packages/galileo_graphql" rel="nofollow"><img src="https://img.shields.io/pub/v/galileo_graphql.svg" alt="Pub" data-canonical-src="https://img.shields.io/pub/v/galileo_graphql.svg" style="max-width:100%;"></a>
<a href="https://travis-ci.org/galileo-dart/graphql" rel="nofollow"><img src="https://travis-ci.org/galileo-dart/graphql.svg" alt="Pub" data-canonical-src="https://img.shields.io/pub/v/galileo_graphql.svg" style="max-width:100%;"></a>
</div>


A complete implementation of the official
[GraphQL specification](https://graphql.github.io/graphql-spec/June2018/),
in the Dart programming language.

The goal of this project is to provide to server-side
users of Dart an alternative to REST API's.

Included is also
`package:galileo_graphql`, which, when combined with the
[Galileo](https://github.com/galileo-dart) framework, allows
server-side Dart users to build backends with GraphQL and
virtually any database imaginable.

## Tutorial Demo (click to watch)
[![Youtube thumbnail](video.png)](https://youtu.be/5x6S4kDODa8)

## Projects
This mono repo is split into several sub-projects,
each with its own detailed documentation and examples:
* `galileo_graphql` - Support for handling GraphQL via HTTP and
WebSockets in the [Galileo](https://galileo-dart.dev) framework. Also serves as the `package:graphql_server` reference implementation.
* `data_loader` - A Dart port of [`graphql/data_loader`](https://github.com/graphql/dataloader).
* `example_star_wars`: An example GraphQL API built using
`package:galileo_graphql`.
* `graphql_generator`: Generates `package:graphql_schema` object types from concrete Dart classes.
* `graphql_parser`: A recursive descent parser for the GraphQL language.
* `graphql_schema`: An implementation of GraphQL's type system. This, combined with `package:graphql_parser`,
powers `package:graphql_server`.
* `graphql_server`: Base functionality for implementing GraphQL servers in Dart. Has no dependency on any
framework.
