# Writing-a-Plugin

[Guidelines](writing-a-plugin.md#guidelines)

Writing a [plug-in](using-plug-ins.md)
is easy. You can provide plug-ins as either functions, or classes:

```dart
AngelConfigurer awesomeify({String message = 'This request was intercepted by an awesome plug-in.'}) {
  return (Angel app) async {
    app.fallback((req, res) async => res.write(message));
  };
}

class MyAwesomePlugin {
  @override
  Future<void> configureServer(Angel app) async {
    app.responseFinalizers.add((req, res) async {
      res.headers['x-be-awesome'] = 'All the time :)';
    });
  }
}

await app.configure(MyAwesomePlugin().configureServer);
```

## Guidelines

* Plugins should only do one thing, or serve one purpose.
* Functions are preferred to classes.
* Always need to be well-documented and thoroughly tested.
* Make sure no other plugin already serves the purpose.
* Use the provided Angel API's whenever possible. This will help your plugin resist breaking change in the future.
* Try to get it added to the `angel-dart` organization (ask in the chat).
* Plugins should *generally* be small, as they usually serve just one purpose.
* Plugins are allowed to modify app configuration.
* Stay away from `req.rawRequest` and `res.rawResponse` if possible. This can restrict people from
using your plugin on multiple platforms.
* Avoid checking `app.isProduction`; leave that to user instead.
* Always use `req.parseBody()` before accessing the request body.

Finally, your plugin should expose common options in a simple way. For example, the \(deprecated\) [compress](https://github.com/angel-dart/compress) plugin has a shortcut function, `gzip`, to set up GZIP compression, whereas for any other codec, you would manually have to specify additional options.

This can greatly aid readability, as there is simply less text to read in the most common cases.

```dart
main() {
  var app = new Angel();

  // Calling gzip()
  app.responseFinalizers.add(gzip());

  // Easier than:
  app.responseFinalizers.add(compress('lzma', lzma));
}
```

