Before starting with the ORM, it is highly recommended to familiar one's self with
`package:angel_serialize`, as it is the foundation for `package:angel_orm`:

https://github.com/angel-dart/serialize

To enable the ORM for a given model, simply add the `@orm` annotation to its definition:

```dart
@orm
@serializable
abstract class _Todo {
    bool get isComplete;

    String get text;

    @Column(type: ColumnType.long)
    int get score;
}
```

The generator will produce a `TodoQuery` class, which contains fields corresponding to each field declared in `_Todo`.
Each of `TodoQuery`'s fields is a subclass of `SqlExpressionBuilder`, corresponding to the given type. For example, `TodoQuery`
would look *something* like:

```dart
class TodoQuery extends Query<Todo, TodoQueryWhere> {
    BooleanSqlExpressionBuilder get isComplete;

    StringSqlExpressionBuilder get text;

    NumericSqlExpressionBuilder<int> get score;
}
```

Thus, you can query the database using plain-old-Dart-objects (*PODO's*):

```dart
Future<List<Todo>> leftToDo(QueryExecutor executor) async {
    var query = TodoQuery()..where.isComplete.isFalse;
    return await query.get(executor);
}

Future<void> markAsComplete(Todo todo, QueryExecutor executor) async {
    var query = TodoQuery()
        ..where.id.equals(todo.idAsInt)
        ..values.isComplete = true;

    await query.updateOne(executor);
}
```

The glue holding everything together is the `QueryExecutor` interface. To support the ORM
for any arbitrary database, simply extend the class and implement its abstract methods.

Consumers of a `QueryExecutor` typically inject it into the app's
[dependency injection](../dependency-injection.md) container:

```dart
app.container.registerSingleton<QueryExecutor>(PostgresExecutor(...));
```

*At the time of this writing*, there is only support for PostgreSQL, though more databases may
be added eventually.