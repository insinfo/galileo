# In-Memory

* [In-Memory Services](in-memory.md#in-memory-services)
* [Next Up...](in-memory.md#next-up)

## In-Memory Services

The simplest data store to set up is an in-memory one, as it does not require external database setup. It only stores Maps, but it can be wrapped in a [`TypedService`](typedservice.md).

```dart
// routes.dart
app.use('/todos', new TypedService<Todo>(new MapService()));

// todo.dart
class Todo extends Model {
  String title;
  bool completed;

  Todo({String id, this.title, this.completed : false}) {
    this.id = id;
  }
}
```

## Next Up...

Learn how to implement your own [custom services](custom-services.md).

