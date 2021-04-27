// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/src/dart/sdk/sdk.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/source.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  var parser = new ArgParser();
  parser.addFlag("dart1",
      help: "Generate output for Dart 1.", negatable: false);
  var options = parser.parse(args);

  if (options.rest.length != 1) {
    print("dart tool/generate.dart path/to/dart1/sdk");
    print("");
    print(parser.usage);
    exitCode = 1;
    return;
  }

  var dart1Dir = options.rest.single;
  if (!new File("$dart1Dir/version").existsSync()) {
    print("It looks like $dart1Dir isn't a Dart SDK.");
    exitCode = 1;
    return;
  }

  var generateDart1 = options["dart1"] as bool;
  print("Generating constants for Dart ${generateDart1 ? 1 : 2}.");

  new Directory("lib").createSync(recursive: true);

  var dart1 = _createContext(dart1Dir);
  var dart2 = _createContext(p.dirname(p.dirname(Platform.resolvedExecutable)));

  for (var lib in dart1.sourceFactory.dartSdk.sdkLibraries) {
    var url = Uri.parse(lib.shortName);
    var name = url.path;
    if (name.startsWith("_")) continue;

    var buffer = new StringBuffer();
    var dart1Library = _library(dart1, url);
    var dart2Library = _library(dart2, url);
    for (var unit in [dart1Library.definingCompilationUnit]
      ..addAll(dart1Library.parts)) {
      for (var variable in unit.topLevelVariables) {
        if (!_isCapsConstant(variable)) continue;

        var newName = _camelCase(variable.displayName);
        var useNewName = !generateDart1 && _find(dart2Library, newName) != null;
        if (!useNewName && _find(dart2Library, variable.displayName) == null) {
          continue;
        }

        buffer.write("const $newName = $name.");
        buffer.write(useNewName ? newName : variable.displayName);
        buffer.writeln(";");
      }

      for (var type in unit.types) {
        if (type.isPrivate) continue;

        // HttpHeaders has constant names where camel-case members already exist
        // (CONTENT_LENGTH etc). I don't want to guess what the migration for
        // these will be so I'm just not converting them.
        if (name == "io" && type.displayName == "HttpHeaders") continue;

        var dart2Type = _find(dart2Library, type.displayName);
        if (dart2Type == null) continue;

        var constants = type.fields
            .where((field) => field.isStatic && _isCapsConstant(field))
            .toList();
        if (constants.isEmpty) continue;

        buffer.writeln("abstract class ${type.displayName} {");
        for (var constant in constants) {
          var newName = _camelCase(constant.displayName);
          var useNewName = !generateDart1 && _find(dart2Type, newName) != null;
          if (!useNewName && _find(dart2Type, constant.displayName) == null) {
            continue;
          }

          buffer.write("static const $newName = $name.${type.displayName}.");
          buffer.write(useNewName ? newName : constant.displayName);
          buffer.writeln(";");
        }
        buffer.writeln("}");
      }
    }
    if (buffer.isEmpty) continue;

    new File("lib/$name.dart").writeAsStringSync("""
// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '$url' as $name;

${new DartFormatter().format(buffer.toString())}""");
  }
}

/// Returns an analysis context for the sdk at [sdkDir].
AnalysisContext _createContext(String sdkDir) {
  var sdk = new FolderBasedDartSdk(PhysicalResourceProvider.INSTANCE,
      PhysicalResourceProvider.INSTANCE.getFolder(sdkDir));
  var uriResolver = new DartUriResolver(sdk);
  var context = AnalysisEngine.instance.createAnalysisContext();
  context.analysisOptions = new AnalysisOptionsImpl()..strongMode = true;
  context.sourceFactory = new SourceFactory([uriResolver]);
  return context;
}

/// Returns the library with the given [url] from [context].
LibraryElement _library(AnalysisContext context, Uri url) =>
    context.computeLibraryElement(context.sourceFactory.forUri(url.toString()));

// Returns the field, variable, or class named [name] in [element], or `null`.
Element _find(Element element, String name) {
  if (element is LibraryElement) {
    return _find(element.definingCompilationUnit, name) ??
        element.parts
            .map((part) => _find(part, name))
            .firstWhere((part) => part != null, orElse: () => null) ??
        element.exportedLibraries
            .map((library) => _find(library, name))
            .firstWhere((library) => library != null, orElse: () => null);
  } else if (element is CompilationUnitElement) {
    return element.topLevelVariables.firstWhere(
            (variable) => variable.displayName == name,
            orElse: () => null) ??
        element.types
            .firstWhere((type) => type.displayName == name, orElse: () => null);
  } else if (element is ClassElement) {
    return element.fields
        .firstWhere((field) => field.displayName == name, orElse: () => null);
  } else {
    return null;
  }
}

/// Constants to skip because they're not being migrated or because they
/// conflict with keywords.
final _skip = ["DEFAULT_BUFFER_SIZE", "DEFAULT", "CONTINUE"];

/// Returns whether [variable] is a screaming-caps constant that should be
/// polyfilled to be camel-case.
bool _isCapsConstant(VariableElement variable) {
  if (!variable.isConst) return false;
  if (_skip.contains(variable.displayName)) return false;
  if (!variable.displayName.contains(new RegExp("^[A-Z]"))) return false;
  return true;
}

/// Special-case identifiers whose camel-casing doesn't follow the normal logic.
final _specialCases = {
  "BASE64URL": "base64Url",
  "SQRT1_2": "sqrt1_2",
  "BIG_ENDIAN": "big",
  "LITTLE_ENDIAN": "little",
  "HOST_ENDIAN": "host"
};

/// Converts a screaming-caps string [caps] to camel-case.
String _camelCase(String caps) {
  var specialCase = _specialCases[caps];
  if (specialCase != null) return specialCase;

  return caps.replaceAllMapped(new RegExp("(_)?([A-Z0-9])"),
      (match) => match[1] == null ? match[2].toLowerCase() : match[2]);
}
