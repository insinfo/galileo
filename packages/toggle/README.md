# deprecated

# toggle

[![version 1.0.0](https://img.shields.io/badge/pub-v1.0.0-brightgreen.svg)](https://pub.dartlang.org/packages/galileo_toggle)
[![build status](https://travis-ci.org/galileo-dart/toggle.svg)](https://travis-ci.org/galileo-dart/toggle)
![coverage: 100%](https://img.shields.io/badge/coverage-100%25-green.svg)

Allows you to substitute one service for another while testing.
The primary use case is to test an application using in-memory services, although it may
be using database services in the real world. This makes tests a bit faster, and also means
that you don't have to write any boilerplate code to clean up a database between test runs.

# Installation
In your `pubspec.yaml` file:
```yaml
dependencies:
  galileo_toggle: ^1.0.0
```

# Usage
Within `galileo_toggle`, there are two ways to specify that your application is running
in "test mode":
  1. `app.properties` contains a key `testMode`, the value of which is `true`.
  2. `Platform.script` contains the string `test` (case-insensitive). This means you have
  to do no further configuration when running from the `test/` directory.
  
This package exports a single plug-in:

## `toggleService`
If the application is running in test mode, then the second generator will be called.
Otherwise, it defaults to the first generator.

If you really need to delay the mounting of the service, add this plug-in to
`app.justBeforeStart`. If no second generator is provided, it will
default to a `MapService`.

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_toggle/galileo_toggle.dart';

configureServer(Galileo app) async {
  await app.configure(toggleService('/api/todos', () => new MongoService(...)));
}
```

Using the plug-in will print a message to the console, notifying you that a service has
been toggled out.
