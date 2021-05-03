# DEPRECATED
`package:jaded` seems to be all but abandoned. Regardless, its approach to templating is far from efficient, and stil doesn't allow for much flexibility in terms of executing code.

Prefer [`jael`](https://github.com/angel-dart/jael), as it is *far* more expressive, works with Dart 2, and is much faster.

# pug
[![version 1.0.0](https://img.shields.io/badge/pub-1.0.0-brightgreen.svg)](https://pub.dartlang.org/packages/angel_pug)
[![build status](https://travis-ci.org/angel-dart/pug.svg)](https://travis-ci.org/angel-dart/pug)

Pug (nee Jade) view generator for Angel.

**`package:jaded` currently is broken on Dart 1.0, so this repo
is blocked until some fix or alternative library comes out.**

# Installation
In your `pubspec.yaml`:

```yaml
dependencies:
  angel_pug: ^1.0.0
```

Also, consider adding the following to your `.gitignore`:
```gitignore
jaded.views.dart
```

# Usage
This package exports a simple
[Angel plugin](https://github.com/angel-dart/angel/wiki/Using-Plug-ins)
that configures your application to render views out of a given directory.

```dart
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_pug/angel_pug.dart';

main() async {
  // ...
  await app.configure(pug(new Directory('views')));
}
```

The `pug` function accepts an optional `Iterable<String> extensions` parameter,
which defaults to `['.pug', '.jade']`. These extensions will be suffixed to template names
when calling `res.render` (i.e. `res.render('foo')` searches for `['foo.pug', 'foo.jade']`)
to find the corresponding view file. 

If you set it to `null` or an empty iterable, then extensions
will not be added. This is a rare case, and only is necessary if your template files have no extensions.
