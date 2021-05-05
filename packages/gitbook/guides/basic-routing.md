* [Routing](basic-routing.md#routing)
* [Route Parameters](basic-routing.md#route-parameters)
  * [Parsing Parameters](basic-routing.md#parsing-parameters)
* [`RegExp` Routes](basic-routing.md#regexp-routes)
* [Mounting and Sub-Apps](basic-routing.md#sub-apps)
* [Route Groups](basic-routing.md#route-groups)
* [Extended Documentation](basic-routing.md#extended-documentation)
* [Next Up...](basic-routing.md#next-up)

## Routing

There is only one method responsible for adding routes to your application:

```dart
app.addRoute('<method>', '<path>', requestHandler);
```

However, the following methods are available for convenience, and are the ones you will use most often. Each method's name responds to an HTTP request method. For example, a route declared with `app.get(...)`, will respond to HTTP `GET` requests.

```dart
app.get('<path>', requestHandler);
app.post('<path>', requestHandler);
app.patch('<path>', requestHandler);
app.delete('<path>', requestHandler);
```

Your `requestHandler` should take the following form:

```dart
typedef FutureOr<dynamic> RequestHandler(RequestContext req, ResponseContext res);
```

Your `requestHandler` can return any Dart value, whether a function, or an object. See the [Requests and Responses](requests-and-responses.md#return-values) pages for detailed documentation.

Route paths _do not_ have to begin with a forward slash, as leading and trailing slashes are stripped from route paths internally.

## Route Parameters

Say you're building an API, or an MVC application. You typically want to serve the same view template on multiple paths, corresponding to different ID's. You can do this as follows, and all parameters will be available via `req.params`:

```dart
app.get('/todos/:id', (req, res) async => {'id': req.params['id']});
```

Remember, route parameters _must_ be preceded by a colon \(':'\). Parameter names must start with a letter or underscore, optionally followed by letters, underscores, or numbers. Parameters will match any character except a forward slash \('/'\) in a request URI.

Examples:

* `:id`
* `:_hello`
* `:param123`
* `info_about_:username`

### Parsing Parameters
With a special syntax, you can build routes that automatically parse parameters as `ints` or `doubles`:

```dart
app
  ..get('/add/int:number', (req, res) => req.params['number'] * 3)
  ..get('/multiply/double:number', (req, res) => req.params['number'] * 5.0);
```

## RegExp Routes

Route parameters can also have custom regular expressions, to remove the requirement of manual parsing. Simply enclose the regular expression in a set of parentheses following the parameter's name.

```dart
app.get(r'/number/:num([0-9]+(\.[0-9])?)', ...);
```

## Sub-Apps

You can `mount` routers, or `use` entire sub-apps.

```dart
var app = new Galileo();
app.get('/', 'Hello!');

var subRouter = new Router()..get('/', 'Subroute');
app.mount('/sub', subApp);
// Now, you can visit /sub and receive the message "Subroute"

var subApp = new Galileo()..get('/hello', 'world');
app.use('/api', subApp);

// GET /api/hello returns "world"
```

## Route Groups

Routes can also be grouped together. Route parameters will be applied to sub-routes automatically. Route groups can be nested as well.

```dart
app.group('/user/:id', (router) {
  router
    ..get('/messages', (String id) => fetchUserMessages(id))
    ..group('/nested', ...);
});
```

## Extended Documentation

For more documentation on the router, see [its repository](https://github.com/galileo-dart/route). [`package:galileo_route`](https://pub.dartlang.org/packages/galileo_route) has no `dart:io` or `dart:mirrors` dependency, and it also supports browser use \(both hash and push state\).

## Next Up...

Learn how [middleware](middleware.md) let you reuse functionality across your entire routing setup.

