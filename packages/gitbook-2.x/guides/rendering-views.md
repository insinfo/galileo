# Rendering-Views

* [Rendering Views](rendering-views.md#rendering-views)
  * [Example](rendering-views.md#example)
  * [`ViewGenerator` typedef](rendering-views.md#viewgenerator)
* [Next Up...](rendering-views.md#next-up)

## Rendering Views

Just like `res.render` in Express, Angel's `ResponseContext` exposes a `Future` called `render`. This invokes whichever function is assigned to your server's `viewGenerator`.

There is a Mustache templating plug-in for Angel available: [https://github.com/angel-dart/mustache](https://github.com/angel-dart/mustache)

There is also [Jael](https://github.com/angel-dart/jael), one of the few actively-developed HTML templating engines for Dart.

Angel support for Jael is provided through [`package:angel_jael`](https://pub.dartlang.org/packages/angel_jael).

Another is Jinja2, which was recently ported by to Dart by
[Olzhas Suleimen](https://github.com/ykmnkmi/jinja.dart).

Angel support for Jinja2 can be found here:
https://pub.dartlang.org/packages/angel_jinja

### Example

```dart
app.get('/view', (req, res) async => await res.render('hello', {'locals': ['foo', 'bar']});
```

### ViewGenerator

Angel declares the following typedef:

```dart
/// A function that asynchronously generates a view from the given path and data.
typedef Future<String> ViewGenerator(String path, [Map data]);
```

A templating plug-in can assign one of these to `app.viewGenerator` to set itself up:

```dart
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';

Future<void> plugin(Angel app) async {
  app.viewGenerator = (String path, [Map data]) async {
    return "Requested view $path with locals: $data";
  };
}

main() async {
  var app = new Angel();
  await app.configure(plugin);
  await app.startServer();
}
```

## Next Up...

1. Explore Angel's isomorphic [client library](https://github.com/angel-dart/client).
2. Find out how to [test Angel applications](testing.md).

