# Controllers

* [Controllers](controllers.md#controllers)
  * [`@Expose()`](controllers.md#expose)
  * [Allowing Null Values](controllers.md#allowing-null-values)
  * [Named Controllers and Actions](controllers.md#named-controllers-and-actions)
  * [Interacting with Requests and Responses](controllers.md#interacting-with-requests-and-responses)
  * [Transforming Data](controllers.md#transforming-data)
* [Next Up...](controllers.md#next-up)

## Controllers

Angel has built-in support for controllers. This is yet another way to define routes in a manageable group, and can be leveraged to structure your application in the [MVC](https://en.wikipedia.org/wiki/Model–view–controller) format. You can also use the [`group()`](basic-routing.md#route-groups) method of any [`Router`](https://www.dartdocs.org/documentation/angel_common/latest/angel_framework/Router-class.html).

The metadata on controller classes is processed via reflection _only once_, at startup. Do not believe that your controllers will be crippled by reflection during request handling, because that possibility is eliminated by [pre-injecting dependencies](dependency-injection.md).

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_container/mirrors.dart';

@Expose("/todos")
class TodoController extends Controller {

  @Expose("/:id")
  getTodo(id) async {
    return await someAsyncAction();
  }

  // You can return a response handler, and have it run as well. :)
  @Expose("/login")
  login() => auth.authenticate('google');
}

main() async {
  Angel app = new Angel(reflector: MirrorsReflector());
  await app.configure(new TodoController().configureServer);
}
```

Rather than extending from `Routable`, controllers act as [plugins](https://github.com/angel-dart/angel/wiki/Using-Plug-ins) when called. This pseudo-plugin will wire all your routes for you.

### @Expose\(\)

The glue that holds it all together is the `Expose` annotation:

```dart
class Expose {
  final String method;
  final Pattern path;
  final List middleware;
  final String as;
  final List<String> allowNull;

  const Expose(Pattern this.path,
      {String this.method: "GET",
      List this.middleware: const [],
      String this.as: null,
      List<String> this.allowNull: const[]});
}
```

### Allowing Null Values

Most fields are self-explanatory, save for `as` and `allowNull`. See, request parameters are mapped to function parameters on each handler. If a parameter is `null`, an error will be thrown. To prevent this, you can pass its name to `allowNull`.

```dart
@Expose("/foo/:id?", allowNull: const["id"])
```

### Named Controllers and Actions

The other is `as`. This allows you to specify a custom name for a controller class or action. `ResponseContext` contains a method, `redirectToAction` that can redirect to a controller action.

```dart
@Expose("/foo")
class FooController extends Controller {
  @Expose("/some/strange/url/:id", as: "bar")
  someActionWithALongNameThatWeWouldLikeToShorten(int id) async {
  }
}

main() async {
  Angel app = new Angel();

  app.get("/some/path", (req, res) async => res.redirectToAction("FooController@bar", {"id": 1337}));
}
```

If you do not specify an `as`, then controllers and actions will be available by their names in code. Reflection is cool, huh?

### Interacting with Requests and Responses

Controllers can also interact with [requests and responses](requests-and-responses.md). All you have to do is declare a `RequestContext` or `ResponseContext` as a parameter, and it will be passed to the function.

```dart
@Expose("/hello")
class HelloController extends Controller {
  @Expose("/")
  Future getIndex(ResponseContext res) async {
    await res.render("hello");
  }
}
```

### Transforming Data

You can use [middleware](middleware.md) to de/serialize data to be processed in a controller method.

```dart
Future<bool> deserializeUser(RequestContext req, res) async {
  var id = req.params['id'] as String;
  req.params['user'] = await asyncFetchUser(id);

  return true;
}

@Expose("/user", middleware: const [deserializeUser])
class UserController extends Controller {

  @Expose("/:id/name")
  Future<String> getUserName(User user) async {
    return user.username;
  }

}

main() async {
  Angel app = new Angel();
  await app.configure(new UserController().configureServer);
}
```

## Next Up...

1. How to [handle parse request bodies](body-parsing.md) with Angel
2. [Using Angel Plug-ins](using-plug-ins.md)

