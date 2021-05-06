import 'package:galileo_serialize_generator/galileo_serialize_generator.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';
import 'build_actions_orm.dart';

final List<BuildAction> buildActions = [
  new BuildAction(
    new PartBuilder([
      const JsonModelGenerator(),
    ]),
    'galileo',
    inputs: const [
      'lib/src/models/*.dart',
    ],
  ),
]..addAll(ormBuildActions);
