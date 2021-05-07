import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

import 'src/description.dart';

Builder messageBuilder(_) => const MessageBuilder();

class MessageBuilder implements Builder {
  const MessageBuilder();

  @override
  final buildExtensions = const {
    '.yaml': ['.dart']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final descriptionsYaml = loadYaml(await buildStep.readAsString(buildStep.inputId)) as Map;
    final descriptions = <Description>[
      for (final name in descriptionsYaml.keys.cast<String>().toList()..sort())
        if (descriptionsYaml[name] is! Map)
          throw Exception('Non-map entry: $name')
        else
          Description.parse(name, descriptionsYaml[name] as Map)
    ];
    final hasCollection = descriptions.any((d) => d.hasCollectionField);
    final enumWireTypes = {
      for (final description in descriptions)
        if (description is EnumType) description.name: description.wireType
    };
    final result = <Spec>[
      for (final description in descriptions) ...description.implementation(enumWireTypes),
      _hashMethods,
      if (hasCollection) _deepEquals,
    ];
    final library = Library((b) => b.body.addAll(result));
    final emitter = DartEmitter(allocator: Allocator.simplePrefixing());
    await buildStep.writeAsString(
        buildStep.inputId.changeExtension('.dart'), DartFormatter().format('${library.accept(emitter)}'));
  }
}

const _deepEquals = Code('''
bool _deepEquals(dynamic left, dynamic right) {
  if (left is List && right is List) {
    final leftLength = left.length;
    final rightLength = right.length;
    if (leftLength != rightLength) return false;
    for(var i = 0; i < leftLength; i++) {
      if(!_deepEquals(left[i], right[i])) return false;
    }
    return true;
  }
  if (left is Map && right is Map) {
    final leftLength = left.length;
    final rightLength = right.length;
    if(leftLength != rightLength) return false;
    for(final key in left.keys) {
      if(!_deepEquals(left[key], right[key])) return false;
    }
    return true;
  }
  return left == right;
}
''');

const _hashMethods = Code('''
int _hashCombine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}
int _hashComplete(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
int _deepHashCode(dynamic value) {
  if (value is List) {
    return value.map(_deepHashCode).reduce(_hashCombine);
  }
  if (value is Map) {
    return (value.keys
            .map((key) => _hashCombine(key.hashCode, _deepHashCode(value[key])))
            .toList(growable: false)
              ..sort())
      .reduce(_hashCombine);
  }
  return value.hashCode;
}
''');
