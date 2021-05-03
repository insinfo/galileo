import 'package:angel_orm_generator/angel_orm_generator.dart';
import 'package:build_runner/build_runner.dart';
import 'package:source_gen/source_gen.dart';

final List<BuildAction> ormBuildActions = [
  new BuildAction(
    new LibraryBuilder(
      const PostgresOrmGenerator(),
      generatedExtension: '.orm.g.dart',
    ),
    'angel',
    inputs: const [
      'lib/src/models/*.dart',
    ],
  ),
];
