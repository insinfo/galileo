# Hooks

* [Hooks](hooks.md#hooks)
* [Bundled Hooks](hooks.md#bundled-hooks)
* [Next Up...](hooks.md#next-up)

## Hooks

Another concept borrowed from FeathersJS is the concept of _hooking services_. This is a mechanism that allows you to separate concerns within your application. For example, many sites send their users confirmation e-mails after successful registration. The logic to do this is often included in the same place as the code to create the user. Hooks allow you to keep the logic for these two tasks, which are more or less unrelated, in two separate places. And what's more, this frees you up to change your service code without having to update the confirmation code in multiple places. For example, you can easily use an in-memory user store in development, and a MongoDB one in production, and use the same confirmation code for each service. So, let's take a look.

When you `use` a service class, Galileo can optionally wrap it in a `HookedService` class. A `HookedService` fires events before and after its inner service runs. This opens the opportunity for events to be canceled, or have parameters modified. `use` takes a named parameter `{bool hooked: true}`. You can also affix a `@Hooked` annotation to your service class for the same effect.

This is similar to middleware, but whereas middleware only runs before requests, hooks can run before and after.

```dart
class HookedService extends Service {
  HookedServiceEventDispatcher beforeIndexed;
  HookedServiceEventDispatcher afterIndexed;

  // And so on...
}
```

A `HookedServiceEventDispatcher` has one key method you will use: `listen`. In a way, this is similar to a broadcast stream, but it has a few catches. These dispatch `HookedServiceEvent` instances, which look like this:

```dart
/// Fired when a hooked service is invoked.
class HookedServiceEvent {
  static const String indexed = "indexed";
  static const String read = "read";
  static const String created = "created";
  static const String modified = "modified";
  static const String updated = "updated";
  static const String removed = "removed";

  /// The inner service whose method was hooked.
  Service service;

  /// The name of the event being fired. This class exposes
  /// some constant Strings you can check for, to prevent typos.
  String eventName;

  /// Read-only: The `id` passed to this event, if any.
  var id;

  /// Same as `id`.
  var data;

  /// Same as `id`. Keep in mind, although this is read-only,
  /// you can still assign values within it.
  Map params;

  /// Read-only. After an event completes, this will hold whatever
  /// value the service method returned.
  var result;

  /// If you call this, no further event callbacks will be fired.
  /// If called on a 'before' hook, no further 'before' events will fire.
  /// Same for an 'after' hook.
  ///
  /// If you call this on a 'before' hook, the actual service method
  /// will never be called. Instead, `result` will be returned as the
  /// response, and any 'after' hooks will see this value as the `result`.
  ///
  /// This is very useful, and allows another way to filter or deny access to
  /// services than traditional middleware.
  void cancel(result);
}
```

```dart
var service = app.service('api/todos') as HookedService;

service.afterCreated.listen((HookedServiceEvent e) {
  // In an `after` hook, `e.result` would be the created data.
  //In this case, it is a Todo object.
  if (!e.result.completed) {
    // Use `cancel` to prematurely end an event. In this case,
    // the following response will be given, rather than a
    // JSON-serialized Todo instance:
    e.cancel({'error': 'Hey, you still have to ${e.text}!'});
  }
});
```

Alternatively, the `Hooks` annotation can be used to assign hooks to service methods.

```dart
helloHook(e) => print('Hello, world!');
fooHook(e) => print('Bar');

@Hooks(before: const [helloHook])
class MyService extends Service {

  @Hooks(before: const [fooHook])
  index([params]) async {
    return ['world'];
  }
}
```

## `package:galileo_hooks`

As of Galileo 2, common hooks can be found in `package:galileo_hooks`:

```dart
import 'package:galileo_hooks/galileo_hooks.dart` as hooks;

main() {
  // ...
  service.listen(hooks.disable());
}
```

## Next Up...

Congratulations! Not only have you gotten through the basic Galileo tutorials, but you've also completed the service tutorials! However, there's still a lot more to Galileo for you to explore. Check out the sidebar for more! _**Happy coding!**_

