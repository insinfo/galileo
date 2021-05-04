# hot
Generates boilerplate for hot-reloading via `package:angel_hot`.

## Generated Code
In `bin/hot.dart`:

```dart
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:<project_name>/<project_name>.dart';

/// Auto-reloads the server on file changes.
main() async {
  var hot = new HotReloader(() async {
    var app = new Angel()..lazyParseBodies = true;
    await app.configure(configureServer);
    return app;
  }, [
    new Directory('config'),
    new Directory('lib'),
  ]);
}
```

Also generates an IntelliJ run configuration.
