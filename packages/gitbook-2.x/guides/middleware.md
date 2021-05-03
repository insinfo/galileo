# Middleware

* [Middleware](middleware.md#middleware)
  * [Denying Requests via Middleware](middleware.md#denying-requests-via-middleware)
  * [Declaring Middleware](middleware.md#declaring-middleware)
  * [Named Middleware](middleware.md#named-middleware)
  * [Global Middleware](middleware.md#global-middleware)
  * [`chain([...])`](middleware.md#chain)
  * [**Maintaining Code Readability](middleware.md#maintaining-code-readability)
* [Next Up...](middleware.md#next-up)

## Middleware

Sometimes, it becomes to recycle code to run on multiple routes. Angel allows for this in the form of _middleware_. Middleware are frequently used as authorization filters, or to serialize database data for use in subsequent routes. Middleware in Angel can be any route handler, whether a function or arbitrary data. You can also throw exceptions in middleware.

### Denying Requests via Middleware

A middleware should return either `true` or `false`. If `false` is returned, no further routes will be executed. If `true` is returned, route evaluation will continue. \(more on request handler return values [here](requests-and-responses.md#return-values)\).

In practice, you will only need to write a `return` statement when you are returning `true`.

As you can imagine, this is perfect for authorization filters.

### Declaring Middleware

You can call a router's `chain` method, or assign middleware in the `middleware` parameter of a route method.

```dart
// All ways ultimately accomplish the same thing.
// Keep it readable!

// Cleanest. Use when it doesn't create visual clutter of its own.
app.chain([cors()]).get('/', 'world!');

// Another readable use of the `.chain()` method.
app.chain([cors()]).get('/something', (req, res) {
  // Do something here...
});

// Use when more than one middleware is involved, or when
// using an anonymous function as a handler (or middleware that spans
// multiple lines)
app.get('/', chain([
  someMiddleware,
  (req, res) => ...,
  (req, res) {
    return 'world!';
  },
]));

// The `middleware: ` parameter is used internally by `package:angel_route`.
// Avoid using it when you can.
app.get('/', 'world!', middleware: [someListOfMiddleware]);
```

Though this might at first seem redundant, there are actually reasons for all three existing.

By convention, though, follow these *readability* rules when building Angel servers:
* Routes with no middleware should not use `chain`, `app.chain`, or `middleware. Self-explanatory.
* Routes with one middleware and one handler should use `app.chain([...])` when:
  * The construction of all the middleware does not take more than one line.
* In all other cases, use the `chain` meta-handler.
* Avoid using `middleware: ...` directly, as it is used internally `package:route`.

### Global Middleware

To add a handler that handles *every* request, call `app.fallback`.
This is merely shorthand for calling `app.all('*', <handler>)`. 
\(more info on request lifecycle [here](request-lifecycle.md)\). 

```dart
app.fallback((req, res) async => res.close());
```

For more complicated middleware, you can also create a class.

Canonically, when using a class as a request handler, it should provide a `handleRequest(RequestContext, ResponseContext)` method. This pattern is seen throughout many Angel plugins, such as `VirtualDirectory` or `Proxy`.

The reason for this is that a name like `handleRequest` makes it very clear to anyone reading the code what it is supposed to do.
This is the same rationale behind [controllers](controllers.md) providing a `configureServer` method.

```dart
class MyCanonicalHandler {
 Future<bool> handleRequest(RequestContext req, ResponseContext res) async {
  // Do something cool...
 }
}

app.use(MyCanonicalHandler().handleRequest);
```

### Maintaining Code Readability

Take the following example. At first glance, it might not be very easy to read.

```dart
app.get('/the-route', chain([
  banIp('127.0.0.1'),
  'auth',
  ensureUserHasAccess(),
  (req, res) async => true,
  takeOutTheTrash()
  (req, res) {
   // Your route handler here...
  }
]));
```

In general, consider it a code smell to stack multiple handlers onto a route like this; it hampers readability,
and in general just doesn't look good.

Instead, when you have multiple handlers, you can split them into multiple `chain` calls, assigned to variables,
which have the added benefit of communicating what each set of middleware does:

```dart
var authorizationMiddleware = chain([
 banIp('127.0.0.1'),
 requireAuthentication(),
 ensureUserHasAccess(),
]);

var someOtherMiddleware = chain([
 (req, res) async => true,
 takeOutTheTrash(),
]);

var theActualRouteHandler = (req, res) async {
 // Handle the request...
};

app.get('/the-route', chain([
 authorizationMiddleware,
 someOtherMiddleware,
 theActualRouteHandler,
]);

```

**Tip**: Prefer using named functions as handlers, rather than anonymous functions, or concrete objects.

## Next Up...

Take a good look at [controllers](controllers.md) in Angel!

