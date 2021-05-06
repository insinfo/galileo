# lumberjack
Improved hierarchical logging for Dart.

```dart
// Simple usage
var logger = Logger('example');
logger.informational('Hey!!!');

// Hierarchy
var baz = logger.createChild('bar').createChild('baz');
baz.notice('example.foo.bar.baz');

// Intercept print, errors.
logger.runZoned(() async {
    await doSomething();
}, onError: () => 34);

logger.error('...', e, st);

// Printing (with colors)
logger.pipe(AnsiLogPrinter.toStdout());
logger.pipe(StringSinkLogPrinter(myStringBuffer));

// Patch over package:logging
var converter = ConvertingLogger(oldLogger);
converter.error('...');
oldLogger.severe('...');

await for (var log in logger) {
    // ... Do something...
}
```
