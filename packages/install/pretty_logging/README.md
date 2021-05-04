# pretty_logging
A simple helper function, `prettyLog`, that prints a `LogRecord` in pretty colors.

# Usage
```dart
import 'dart:async';
import 'package:<project-name>/<project-name>.dart';
import 'package:<project-name>/src/pretty_logging.dart';

Future configureServer(Angel app) async {
  app.logger = new Logger('angel')
    ..onRecord.listen(prettyLog);
}
```
