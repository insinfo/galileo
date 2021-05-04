import 'package:angel_orm_generator/angel_orm_generator.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';

final List<BuildAction> ormBuildActions = [
  new BuildAction(
    new LibraryBuilder(
      const PostgresOrmGenerator(),
      generatedExtension: '.orm.g.dart',
    ),
    '{{ project_name }}',
    inputs: const [
      '{{ inputs }}',
    ],
  ),
];
