import 'package:build_runner/build_runner.dart';
import 'package:owl_codegen/json_generator.dart';
import 'package:source_gen/source_gen.dart';

final PhaseGroup phaseGroup = new PhaseGroup.singleAction(
    new GeneratorBuilder([new JsonGenerator()], isStandalone: true),
    new InputSet('instagram', const [
      'lib/src/models/models.dart',
      'lib/src/models/impl_models.dart'
    ]));
