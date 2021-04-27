This package is a polyfill for the core library constant names that are changing
from Dart 1 to Dart 2.

In Dart 1, all core library constants were in `SCREAMING_CAPS`. In Dart 2,
they're being changed to `camelCase`. This package makes it possible for
packages to support both Dart 1 and Dart 2 by providing `camelCase` constants
that work on all versions of Dart.

This package has a library for each library `dart:` library that contained
constants in Dart 1. These libraries contain only constants, using the Dart 2
names. They should be imported using a prefix so as to avoid colliding with core
library names:

```dart
import 'package:dart2_constant/convert.dart' as convert;

String decodeUtf8(List<int> bytes) => convert.utf8.decode(bytes);
```

Note that this even supports constants that haven't yet migrated in the core
libraries, such as those in `dart:io` and `dart:html`. These are provided for
compatibility with future SDK changes.

## How It Works

Each version of `dart2_constant` has two releases, one tagged `+dart1` that's
only compatible SDKs that have old-style constants and one tagged `+dart2`
that's only compatible with SDKs that have new-style constants. As long as you
depend on `dart2_constant`, pub's version solver will make sure your users get
a version of it that works for them.

## See Also

The [`dart2_fix`][] package can be used to automatically migrate constant
references from Dart 1 style to Dart 2 style. It doesn't [currently][] support
migrating to `dart2_constant` references, though.

[`dart2_fix`]: https://pub.dartlang.org/packages/dart2_fix
[currently]: https://github.com/dart-lang/dart2_fix/issues/18
