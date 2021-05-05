# Custom-Services

* [Custom Services](custom-services.md#custom-services)
  * [`AnonymousService`](custom-services.md#anonymousservice)
* [Next Up...](custom-services.md#next-up)

## Custom Services

Assuming you have already read [Service Basics](service-basics.md), the process of implementing your own service is very straightforward. Simply implement the methods you want to expose.

By default, a service will throw a `405 Method Not Allowed` error if you haven't written any logic to handle a given method. This means you only need to write handlers for operations you plan to actually have carried out.

Do make sure to invoke the `super` constructor in any of your constructors, as that's where services set up their routes. Without it, your service will not be accessible to the Internet, as it will not have any front-facing routes set up at all.

```dart
class MyService extends Service {
  MyService():super() {
    // Feel free to add your own constructor, just don't
    // neglect the `super`...
  }
}
```

Alternatively, consider using [service hooks](hooks.md). They are the preferred method of modifying Galileo services because they do not depend on service implementations.

_Note_: The convention for the `remove` method on services is that if `id == null`, _all entries in the store should be removed_. Obviously, this does not work very well in production, so only allow this to occur on the server side. Common service providers will disable this for clients, unless you explicitly set a flag dictating so.

### AnonymousService

If you only need to implement a small selection of the common service methods, consider using an `AnonymousService`. They are the functional equivalent of creating a new service class. **Please do not use anonymous services in library packages.**

```dart
app.use('/todos', new AnonymousService(index: ([params]) => somehowFetchTodos()));
```

## Next Up...

Find out how to filter and react to service events with [hooks](hooks.md).

