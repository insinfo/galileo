# serialize
This add-on generates boilerplate for using `package:angel_serialize`.

## Parameters
* `inputs`: The glob representing model files (default: `lib/src/models/*.dart`)

## Generated Code
```dart
// tool/build.dart
import 'package:build_runner/build_runner.dart';
import 'build_actions.dart';

main() => build(buildActions, deleteFilesByDefault: true);

// tool/build_actions.dart
import 'package:angel_serialize_generator/angel_serialize_generator.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';

final List<BuildAction> buildActions = [
  new BuildAction(
    new PartBuilder([
      const JsonModelGenerator(),
    ]),
    '<project-name>',
    inputs: const [
      'lib/src/models/*.dart',
    ],
  ),
];

// tool/watch.dart
import 'package:build_runner/build_runner.dart';
import 'build_actions.dart';

main() => watch(buildActions, deleteFilesByDefault: true);
```

Also generates IntellIJ run configurations.
