# Using-Plug-ins

* [Using Plug-ins](using-plug-ins.md#using-plug-ins)
  * [Execution Order](using-plug-ins.md#execution-order)
  * [Writing a Plug-in](https://github.com/angel-dart/angel/wiki/Writing-a-Plugin)
* [Next Up...](using-plug-ins.md#next-up)

## Using Plug-ins

Angel is designed to be extensible. As such, it exposes a typedef, `AngelConfigurer`, that has special privileges within the framework - they act as plug-ins and can be called via `app.configure()`.

Plug-ins simply need to accept an `Angel` instance as a parameter, and return a `Future` \(the result of which will be ignored, unless it throws an error\). `Angel` instances have several facilities available to be customized, and thus it is easy to use a custom plug-in to bring about desired functionality within your application.

```dart
typedef Future AngelConfigurer(Angel app);
```

As a convention, Angel plug-ins should be hooked up **before** the call to `startServer`.

```dart
import 'dart:io';
import 'package:angel_framework/angel_framework';

plugin(Angel app) async {
  print("Do stuff here");
}

main() async {
  Angel app = new Angel();
  await app.configure(plugin);
  await app.startServer();
}
```

### Execution Order

Plugins are usually immediately invoked by `app.configure()`. However, you may run into certain plug-ins
that depend on other facilities already being available, or all of your [services](ervice-basics.md) already being mounted. You can set aside a plug-in to be run just before server startupby adding it to `app.startupHooks`, instead of directly calling `app.configure()`.

```dart
app.startupHooks.addAll([
  myPlugin(),
  AngelWebSocket().configureServer,
  fooBarBazQuux()
]);
```

Likewise, you can add hooks that run just before the app is shutdown, via `Angel.shutdownHooks`.

## Next Up...

Learn how to generate content for clients by [rendering views](rendering-views.md).

