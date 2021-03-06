# galileo_orm_service
[![Pub](https://img.shields.io/pub/v/galileo_orm_service.svg)](https://pub.dartlang.org/packages/galileo_orm_service)
[![build status](https://travis-ci.org/galileo-dart/orm.svg)](https://travis-ci.org/galileo-dart/orm)

Service implementation that wraps over galileo ORM Query classes.

## Installation
In your `pubspec.yaml`:

```yaml
dependencies:
    galileo_orm_service: ^1.0.0
```

## Usage
Brief snippet (check `example/main.dart` for setup, etc.):

```dart
// Create an ORM-backed service.
  var todoService = OrmService<int, Todo, TodoQuery>(
      executor, () => TodoQuery(),
      readData: (req, res) => todoSerializer.decode(req.bodyAsMap));

  // Because we provided `readData`, the todoService can face the Web.
  // **IMPORTANT: Providing the type arguments is an ABSOLUTE MUST, if your
  // model has `int` ID's (this is the case when using `galileo_orm_generator` and `Model`).
  // **
  app.use<int, Todo, OrmService<int, Todo, TodoQuery>>(
      '/api/todos', todoService);
```
