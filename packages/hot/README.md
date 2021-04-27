# hot

Supports *hot reloading* of Galileo servers on file changes. This is faster and
more reliable than merely reactively restarting a `Process`.

This package only works with the [Galileo framework](https://github.com/Galileo-dart/Galileo).

# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  Galileo_framework: ^2.0.0-alpha
  Galileo_hot: ^2.0.0
```

# Usage
This package is dependent on the Dart VM service, so you *must* run
Dart with the `--observe` (or `--enable-vm-service`) argument!!!

Usage is fairly simple. Pass a function that creates an `Galileo` server, along with a collection of paths
to watch, to the `HotReloader` constructor. The rest is history!!!

The recommended pattern is to only use hot-reloading in your application entry point. Create your `Galileo` instance
within a separate function, conventionally named `createServer`. 

**Using this in production mode is not recommended, unless you are
specifically intending for a "hot code push" in production..**

You can watch:
  * Files
  * Directories
  * Globs
  * URI's
  * `package:` URI's
  
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Galileo_framework/Galileo_framework.dart';
import 'package:Galileo_hot/Galileo_hot.dart';
import 'package:logging/logging.dart';
import 'src/foo.dart';

main() async {
  var hot = new HotReloader(createServer, [
    new Directory('src'),
    new Directory('src'),
    'main.dart',
    Uri.parse('package:Galileo_hot/Galileo_hot.dart')
  ]);
  await hot.startServer('127.0.0.1', 3000);
}

Future<Galileo> createServer() async {
  var app = new Galileo()..serializer = json.encode;

  // Edit this line, and then refresh the page in your browser!
  app.get('/', (req, res) => {'hello': 'hot world!'});
  app.get('/foo', (req, res) => new Foo(bar: 'baz'));

  app.fallback((req, res) => throw new GalileoHttpException.notFound());

  app.encoders.addAll({
    'gzip': gzip.encoder,
    'deflate': zlib.encoder,
  });

  app.logger = new Logger('Galileo')
    ..onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) {
        print(rec.error);
        print(rec.stackTrace);
      }
    });

  return app;
}
```
