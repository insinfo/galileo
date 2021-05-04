import 'generator.dart';
import 'package:code_builder/code_builder.dart';
import 'package:inflection3/inflection3.dart';
import '../make/maker.dart';

class FileServiceGenerator extends ServiceGenerator {
  const FileServiceGenerator() : super('Persistent JSON File');

  @override
  List<MakerDependency> get dependencies => const [const MakerDependency('galileo_file_service', '^3.0.2')];

  @override
  bool get goesFirst => true;

  @override
  void applyToConfigureServer(
      LibraryBuilder library, MethodBuilder configureServer, BlockBuilder block, String name, String lower) {
    configureServer.requiredParameters.add(new Parameter((b) => b
      ..name = 'dbDirectory'
      ..type = refer('Directory')));
  }

  @override
  void applyToLibrary(LibraryBuilder library, String name, String lower) {
    library.directives.addAll([
      new Directive.import('package:galileo_file_service/galileo_file_service.dart'),
    ]);
  }

  @override
  Expression createInstance(LibraryBuilder library, MethodBuilder methodBuilder, String name, String lower) {
    library.directives.addAll([
      new Directive.import('package:file/file.dart'),
    ]);
    return refer('JsonFileService').newInstance([
      refer('dbDirectory').property('childFile').call([literal(pluralize(lower) + '_db.json')])
    ]);
  }
}
