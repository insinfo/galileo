# shelf
[![Pub](https://img.shields.io/pub/v/galileo_shelf.svg)](https://pub.dartlang.org/packages/galileo_shelf)
[![build status](https://travis-ci.org/galileo-dart/shelf.svg)](https://travis-ci.org/galileo-dart/shelf)

Shelf interop with Galileo. This package lets you run `package:shelf` handlers via a custom adapter. 

Use the code in this repo to embed existing Galileo/shelf apps into
other Galileo/shelf applications. This way, you can migrate legacy applications without
having to rewrite your business logic.

This will make it easy to layer your API over a production application,
rather than having to port code.

- [Usage](#usage)
  - [embedShelf](#embedshelf)
    - [Communicating with Galileo](#communicating-with-galileo-with-embedshelf)
  - [`GalileoShelf`](#galileoshelf)

# Usage

## embedShelf

This is a compliant `shelf` adapter that acts as an Galileo request handler. You can use it as a middleware,
or attach it to individual routes.

```dart
import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_shelf/galileo_shelf.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'api/api.dart';

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);

  // Galileo routes on top
  await app.mountController<ApiController>();

  // Re-route all other traffic to an
  // existing application.
  app.fallback(embedShelf(
    shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest)
  ));

  // Or, only on a specific route:
  app.get('/shelf', wrappedShelfHandler);

  await http.startServer(InternetAddress.loopbackIPV4, 3000);
  print(http.uri);
}
```

### Communicating with Galileo with embedShelf

You can communicate with Galileo:

```dart
handleRequest(shelf.Request request) {
  // Access original Galileo request...
  var req = request.context['galileo_shelf.request'] as RequestContext;

  // ... And then interact with it.
  req.container.registerNamedSingleton<Foo>('from_shelf', Foo());

  // `req.container` is also available.
  var container = request.context['galileo_shelf.container'] as Container;
  container.make<Truck>().drive();
}
```

### GalileoShelf
Galileo 2 brought about the generic `Driver` class, which is implemented
by `GalileoHttp`, `GalileoHttp2`, `GalileoGopher`, etc., and provides the core
infrastructure for request handling in Galileo.

`GalileoShelf` is an implementation that wraps shelf requests and responses in their
Galileo equivalents. Using it is as simple using as using `GalileoHttp`, or any other
driver:

```dart
// Create an GalileoShelf driver.
// If we have startup hooks we want to run, we need to call
// `startServer`. Otherwise, it can be omitted.
// Of course, if you call `startServer`, know that to run
// shutdown/cleanup logic, you need to call `close` eventually,
// too.
var galileoShelf = GalileoShelf(app);
await galileoShelf.startServer();

await shelf_io.serve(galileoShelf.handler, InternetAddress.loopbackIPv4, 8081);
```

You can also use the `GalileoShelf` driver as a shelf middleware - just use
`galileoShelf.middleware` instead of `galileoShelf.handler`. When used as a middleware,
if the Galileo response context is still open after all handlers run (i.e. no routes were
matched), the next shelf handler will be called.

```dart
var handler = shelf.Pipeline()
  .addMiddleware(galileoShelf.middleware)
  .addHandler(createStaticHandler(...));
```
