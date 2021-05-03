# TypedService

* [`TypedService`](typedservice.md#typedservice)
* [Next Up...](typedservice.md#next-up)

## TypedService

The vast majority of database adapters for Angel never touch any Dart objects other than Maps. This is good because you are not forced to run reflective code on every query, so you won't wind up creating any inescapable bottlenecks.

However, oftentimes, you will want to serialize and deserialize data in the form of a model class. A `TypedService<T>` performs this for you, and can wrap any other service. Just ensure that your `T` type extends `Model`, found in `package:angel_framework/common.dart`. Combined with the general service pattern, this serves as a sort of mini-ORM that is also database agnostic.

```dart
// foo.dart
class Foo extends Model {
  String bar;

  Foo({this.bar});
}

// foo_service.dart
app.use('/foo', new TypedService<Foo>(new RethinkService(conn, r.table('foo')));

// blah_blah_blah.dart
Foo foo = await app.service('foo').create({'bar': 'baz'});
Foo otherFoo = await app.service('foo').create(new Foo(bar: 'quux'));
```

As a bonus, `Model` classes can be used on the client and server sides of your application. Hurrah!

## Next Up...

See how the `MapService` class lets you manage data [in-memory](https://github.com/angel-dart/angel/wiki/In-Memory).

