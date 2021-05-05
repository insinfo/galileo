# Dependency-Injection

Galileo uses a [container hierarchy](https://github.com/galileo-dart/container) for DI.
Dependency injection makes it easier to build applications with multiple moving parts, because logic can be contained in one location and reused at another place in your application.

## Adding a Singleton

```dart
Future<void> myPlugin(Galileo app) async  {
  app.container.registerSingleton(SomeClass("foo"));
  app.container.registerSingleton<SomeAbstractClass>(MyImplClass());
  app.container.registerFactory((_) => SomeClass("foo"));
  app.container.registerLazySingleton((_) => SomeOtherClass());
  app.container.registerNamedSingleton('yes', Yes());
}
```

You can also inject within a `RequestContext`, as each one has a `controller` property
that extends from the app's global container.

Accessing these injected properties is easy, and strongly typed:

```dart
// Inject types.
var todo = req.container.make<Todo>();
print(todo.isComplete);

// Or by name
var db = await req.container.findByName<Db>('database');
var collection = db.collection('pets');
```

## In Routes and Controllers
In Galileo 2.0, by wrapping a function in a call to `ioc`, you can automatically
inject the dependencies of any route handler.

```dart
app.get("/some/class/text", ioc((SomeClass singleton) => singleton.text)); // Always "foo"

app.post("/foo", ioc((SomeClass singleton, {Foo optionalInjection}));

@Expose("/my/controller")
class MyController extends Controller {

  @Expose("/bar")
  // Inject classes from container, request parameters or the request/response context :)
  bar(SomeClass singleton, RequestContext req) => "${singleton.text} bar"; // Always "foo bar"

  @Expose("/baz")
  baz({Foo optionalInjection});
}
```

As you can imagine, this is very useful for managing things such as database connections.

```dart
configureServer(Galileo app) async {
  var db = Db("mongodb://localhost:27017/db");
  await db.open();
  app.container.registerSingleton(db);
}

@Expose("/users")
class ApiController extends Controller {
  @Expose("/:id")
  fetchUser(String id, Db db) => db.collection("users").findOne(where.id(ObjectId.fromHexString(id)));
}
```

## Dependency-Injected Controllers

`Controller`s have dependencies injected without any additional configuration by you. However, you might want to inject dependencies into the constructor of your controller.

```dart
@Expose('/controller')
class MyController {
  final GalileoAuth auth;
  final Db db;

  MyController(this.auth, this.db);

  @Expose('/login')
  login() => auth.authenticate('local');
}

main() async {
  // At some point in your application, register necessary dependencies as singletons...
  app.container.registerSingleton(auth);
  app.container.registerSingleton(db);

  // Create the controller with injected dependencies
  await app.mountController<MyController>();
}
```

## Enabling `dart:mirrors` or other Reflection
By default, Galileo will use the `EmptyReflector()` to power its `Container` instances,
which has no support for `dart:mirrors`, so that it can be used in contexts where Dart
reflection is not available.

However, by using a different `Reflector`, you can use the full power of Galileo's DI system.
`galileo init` projects use the `MirrorsReflector()` by default.

If your application is using any sort of functionality reliant on annotations or reflection,
either include the MirrorsReflector, or use a static reflector variant.

The following use cases require reflection:
* Use of `Controller`s, via `@Expose()` or `@ExposeWS()`
* Use of dependency injection into **constructors**, whether in controllers or plain `container.make` calls
* Use of the `ioc` function in any route

The `MirrorsReflector` from `package:galileo_container/mirrors.dart` is by far the most convenient pattern,
so use it if possible.

However, the following alternatives exist:
* Generation via `package:galileo_container_generator`
* Creating an instance of `StaticReflector`
* Manually implementing the `Reflector` interface (cumbersome; not recommended)
