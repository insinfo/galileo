# sql
Infrastructure for interacting with SQL databases, while still using the Angel `Service` API.

## Why not a dedicated ORM?
A better question, is *why* have an ORM dedicated to just one database, when Angel supports multiple databases?

`package:angel_sql` was the compromise between having an ORM,
and not having an ORM.

### Advantages of this Approach
* Users of SQL databases get all of the benefits of `Service`,
including:
    * Services instantly map to CRUD REST API's
    * Services can use common hooks, like authorization and
    other security hooks
    * Services can broadcast events via WebSockets
    * Services are sub-routers, and thus can have their
    own request handlers

### Disadvantages
* `angel_sql`'s base `SqlService` doesn't provide fine-grained
control on the default CRUD methods.
    * However, if you need specific queries, you can use a hook,
    a custom route, extend the service, or wrap it with an
    `AnonymousService`. There are several ways to get around
    this.
* In addition to the above, instead of having a Dart DSL
for writing queries, you'll probably be using raw SQL for
fine-grained control.
    * Not everybody might consider this a disadvantage,
    though.
    * Things like joins and unions will be easier to
    reason about, anyways, since there's no intermediate
    layer between queries and data.