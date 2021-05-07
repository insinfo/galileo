import 'package:code_builder/code_builder.dart';

import 'equality.dart';
import 'fields.dart';
import 'hash_code.dart';

abstract class Description {
  Iterable<Spec> implementation(Map<String, Reference> enumWireTypes);
  bool get hasCollectionField;
  factory Description.parse(String name, Map params) {
    if (params.containsKey('enumValues')) {
      return EnumType(name, params['wireType'] as String,
          _parseEnumValues(params['enumValues'] as Map));
    }
    if (params.containsKey('subclassBy')) {
      return _parseSubclassedMessage(name, params);
    }
    final fields = params.containsKey('fields')
        ? MessageField.parse(params['fields'] as Map)
        : MessageField.parse(params);
    return Message(name, fields);
  }
}

Description _parseSubclassedMessage(String name, Map params) {
  final parentField = params['subclassBy'] as Map;
  final subclasses = <Message>[];
  final subclassSelections = <Expression, String>{};
  final descriptions = params['subclasses'] as Map;
  for (var subclass in descriptions.keys.cast<String>().toList()..sort()) {
    final description = descriptions[subclass] as Map;
    final fields = {};
    if (description.containsKey('fields')) {
      fields.addAll(description['fields'] as Map);
    }
    final parentFieldToken = literal(description['selectOn']);
    subclasses.add(Message(subclass, MessageField.parse(fields), name,
        parentField.keys.single as String, parentFieldToken));
    subclassSelections[parentFieldToken] = subclass;
  }
  return SubclassedMessage(
      name, subclasses, parentField.keys.single as String, subclassSelections);
}

Iterable<EnumValue> _parseEnumValues(Map values) {
  final names = values.keys.cast<String>().toList()..sort();
  return names.map((name) => EnumValue(name, values[name]));
}

class EnumType implements Description {
  final String name;
  final Reference wireType;
  final Iterable<EnumValue> values;
  EnumType(this.name, String wireType, this.values)
      : wireType = refer(wireType);
  @override
  bool get hasCollectionField => false;

  @override
  Iterable<Spec> implementation(Map<String, Reference> enumWireTypes) {
    final constValues = values.map((v) => Field((b) => b
      ..static = true
      ..modifier = FieldModifier.constant
      ..name = v.name
      ..assignment = refer(name).constInstanceNamed('_', [v.wireId]).code));
    final valueField = Field((b) => b
      ..modifier = FieldModifier.final$
      ..type = wireType
      ..name = '_value');
    final valueMap = {
      for (var v in values) v.wireId: refer(name).property(v.name)
    };
    final fromJson = Constructor((b) => b
      ..factory = true
      ..name = 'fromJson'
      ..requiredParameters.add(Parameter((b) => b
        ..name = 'value'
        ..type = wireType))
      ..body = Block.of([
        literalConstMap(valueMap).assignConst('values').statement,
        refer('values').index(refer('value')).returned.statement
      ]));
    final unnamed = Constructor((b) => b
      ..constant = true
      ..name = '_'
      ..requiredParameters.add(Parameter((b) => b..name = 'this._value')));
    final toJson = Method((b) => b
      ..returns = wireType
      ..name = 'toJson'
      ..lambda = true
      ..body = refer('_value').code);
    return [
      Class((b) => b
        ..name = name
        ..fields.addAll(constValues)
        ..fields.add(valueField)
        ..constructors.add(fromJson)
        ..constructors.add(unnamed)
        ..methods.add(toJson))
    ];
  }
}

class EnumValue {
  final String name;
  final Expression wireId;
  EnumValue(this.name, dynamic /*String|int*/ wireValue)
      : wireId = literal(wireValue);
}

class SubclassedMessage implements Description {
  final String name;
  final List<Message> subclasses;
  final String subclassBy;
  final Map<Expression, String> subclassSelections;
  SubclassedMessage(
      this.name, this.subclasses, this.subclassBy, this.subclassSelections);

  @override
  bool get hasCollectionField => subclasses.any((m) => m.hasCollectionField);

  @override
  Iterable<Spec> implementation(Map<String, Reference> enumWireTypes) {
    final selection = <Code>[
      refer('params')
          .index(literalString(subclassBy))
          .assignFinal('selectBy')
          .statement
    ];
    for (final key in subclassSelections.keys) {
      final ctor = '${subclassSelections[key]}.fromJson(params)';
      selection.add(Code('if (selectBy == $key) return $ctor;'));
    }
    selection.add(
        Code("throw ArgumentError('Could not match $name for \$selectBy');"));
    final fromJson = Constructor((b) => b
      ..factory = true
      ..name = 'fromJson'
      ..requiredParameters.add((Parameter((b) => b
        ..type = refer('Map')
        ..name = 'params')))
      ..body = Block.of(selection));
    final toJson = Method((b) => b
      ..returns = refer('Map')
      ..name = 'toJson');
    return [
      Class((b) => b
        ..abstract = true
        ..name = name
        ..constructors.add(fromJson)
        ..methods.add(toJson)),
      for (var subclass in subclasses) ...subclass.implementation(enumWireTypes)
    ];
  }
}

class Message implements Description {
  final String name;
  final List<MessageField> fields;
  final String parent;
  final String parentField;
  final Expression parentFieldToken;
  Message(this.name, this.fields,
      [this.parent, this.parentField, this.parentFieldToken]);

  String get _builderName => '$name\$Builder';

  @override
  bool get hasCollectionField =>
      fields.any((f) => f.type is ListFieldType || f.type is MapFieldType);

  @override
  Iterable<Spec> implementation(Map<String, Reference> enumWireTypes) {
    final fieldDeclarations = fields
        .map((f) => f.declaration)
        .map((d) => d.rebuild((b) => b.modifier = FieldModifier.final$))
        .toList();
    if (parentField != null) {
      fieldDeclarations.add(Field((b) => b
        ..modifier = FieldModifier.final$
        ..name = parentField
        ..assignment = parentFieldToken.code));
    }
    final toJsonMap = {
      for (var f in fields) literalString(f.name): f.type.toJson(refer(f.name))
    };
    if (parentField != null) {
      toJsonMap[literalString(parentField)] = parentFieldToken;
    }
    final implements = parent == null ? <Reference>[] : [refer(parent)];
    final toJson = Method((b) {
      b
        ..returns = refer('Map')
        ..name = 'toJson'
        ..lambda = true
        ..body = literalMap(toJsonMap).code;
      if (implements.isNotEmpty) {
        b.annotations.add(refer('override'));
      }
    });
    final clazz = Class((b) => b
      ..name = name
      ..implements.addAll(implements)
      ..fields.addAll(fieldDeclarations)
      ..constructors.addAll(_ctors(enumWireTypes))
      ..methods.add(toJson)
      ..methods.add(buildHashCode(name, fields))
      ..methods.add(buildEquals(name, fields)));
    final builder = Class((b) => b
      ..name = _builderName
      ..fields.addAll(fields.map((f) => f.declaration))
      ..constructors.add(Constructor((b) => b..name = '_')));
    return [
      clazz,
      builder,
    ];
  }

  Iterable<Constructor> _ctors(Map<String, Reference> enumWireTypes) =>
      fields.isNotEmpty
          ? [
              Constructor((b) => b
                ..name = '_'
                ..requiredParameters.addAll(fields
                    .map((f) => Parameter((b) => b..name = 'this.${f.name}')))),
              Constructor((b) => b
                ..factory = true
                ..requiredParameters.add(Parameter((b) => b
                  ..type = FunctionType((b) => b
                    ..returnType = refer('void')
                    ..requiredParameters.add(refer(_builderName)))
                  ..name = 'init'))
                ..body = Block.of([
                  refer(_builderName)
                      .newInstanceNamed('_', [])
                      .assignFinal('b')
                      .statement,
                  refer('init').call([refer('b')]).statement,
                  refer(name)
                      .newInstanceNamed(
                          '_', fields.map((f) => refer('b').property(f.name)))
                      .returned
                      .statement,
                ])),
              Constructor((b) => b
                ..factory = true
                ..name = 'fromJson'
                ..lambda = true
                ..requiredParameters.add(Parameter((b) => b
                  ..type = refer('Map')
                  ..name = 'params'))
                ..body = refer(name)
                    .newInstanceNamed(
                        '_', fields.map((f) => f.fromParams(enumWireTypes)))
                    .code),
            ]
          : [
              Constructor((b) => b..constant = true),
              Constructor((b) => b
                ..constant = true
                ..name = 'fromJson'
                ..optionalParameters.add(Parameter((b) => b..name = '_')))
            ];
}
