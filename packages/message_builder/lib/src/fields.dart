import 'package:code_builder/code_builder.dart';

class MessageField {
  final String name;
  final FieldType type;
  MessageField(this.name, this.type);

  Expression fromParams(Map<String, Reference> enumWireTypes) {
    final paramValue = refer('params').index(literalString(name));
    final toType = type.fromParams(paramValue, enumWireTypes);
    return refer('params')
        .property('containsKey')
        .call([literalString(name)])
        .and(refer('params').index(literalString(name)).notEqualTo(literalNull))
        .conditional(toType, literalNull);
  }

  Field get declaration => Field((b) => b
    ..type = type.type
    ..name = name);

  Expression equalityCheck(String other) =>
      type.equalityCheck(name, '$other.$name');

  static List<MessageField> parse(Map fields) {
    final names = fields.keys.cast<String>().toList()..sort();
    return names
        .map((name) => MessageField(name, FieldType.parse(fields[name])))
        .toList();
  }
}

const _primitives = ['String', 'int', 'bool', 'dynamic'];

abstract class FieldType {
  Expression toJson(Expression e);
  Expression fromParams(
      Expression fieldValue, Map<String, Reference> enumWireTypes);
  Reference get type;
  bool get isPrimitive;
  bool get canCastInCollection;
  Expression equalityCheck(String leftToken, String rightToken);

  factory FieldType.parse(dynamic /*String|Map*/ field) {
    if (field is String) {
      if (_primitives.contains(field)) return PrimitiveFieldType(field);
      return MessageFieldType(field);
    }
    if (field is Map) {
      if (field.containsKey('listType')) {
        return ListFieldType(FieldType.parse(field['listType']));
      }
      if (field.containsKey('mapType')) {
        return MapFieldType(FieldType.parse(field['mapType']));
      }
    }
    throw 'Unhandled field type [$field]';
  }
}

class PrimitiveFieldType implements FieldType {
  final String name;
  PrimitiveFieldType(this.name);

  @override
  Expression toJson(Expression e) => e;

  @override
  Expression fromParams(Expression fieldValue, Map<String, Reference> _) =>
      fieldValue.asA(type);

  @override
  Reference get type => refer(name);

  @override
  final isPrimitive = true;

  @override
  final canCastInCollection = true;

  @override
  Expression equalityCheck(String leftToken, String rightToken) =>
      refer(leftToken).equalTo(refer(rightToken));
}

class MessageFieldType implements FieldType {
  final String name;
  MessageFieldType(this.name);

  @override
  Expression toJson(Expression e) => e.nullSafeProperty('toJson').call([]);

  @override
  Expression fromParams(
      Expression fieldValue, Map<String, Reference> enumWireTypes) {
    final castType =
        enumWireTypes.containsKey(name) ? enumWireTypes[name] : refer('Map');
    return refer(name).newInstanceNamed('fromJson', [fieldValue.asA(castType)]);
  }

  @override
  Reference get type => refer(name);

  @override
  final isPrimitive = false;

  @override
  final canCastInCollection = false;

  @override
  Expression equalityCheck(String leftToken, String rightToken) =>
      refer(leftToken).equalTo(refer(rightToken));
}

class ListFieldType implements FieldType {
  final FieldType typeArgument;
  ListFieldType(this.typeArgument);

  @override
  Expression toJson(Expression e) {
    if (typeArgument.isPrimitive) return e;
    final toJsonClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add((Parameter((b) => b..name = 'v')))
      ..body = typeArgument.toJson((refer('v'))).code).closure;
    return e
        .nullSafeProperty('map')
        .call([toJsonClosure])
        .nullSafeProperty('toList')
        .call([]);
  }

  @override
  Expression fromParams(
      Expression fieldValue, Map<String, Reference> enumWireTypes) {
    if (typeArgument.canCastInCollection) {
      return fieldValue
          .asA(refer('List'))
          .property('cast')
          .call([], {}, [typeArgument.type]);
    }
    final fromJsonClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = typeArgument.fromParams(refer('v'), enumWireTypes).code).closure;
    return fieldValue
        .asA(refer('List'))
        .property('map')
        .call([fromJsonClosure])
        .property('toList')
        .call([]);
  }

  @override
  Reference get type => TypeReference((b) => b
    ..symbol = 'List'
    ..types.add(typeArgument.type));

  @override
  bool get isPrimitive => typeArgument.isPrimitive;

  @override
  final canCastInCollection = false;

  @override
  Expression equalityCheck(String leftToken, String rightToken) =>
      refer('_deepEquals').call([refer(leftToken), refer(rightToken)]);
}

class MapFieldType implements FieldType {
  final FieldType typeArgument;
  MapFieldType(this.typeArgument);

  @override
  Expression toJson(Expression e) {
    if (typeArgument.isPrimitive) return e;
    final toMapEntryClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'k'))
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = refer('MapEntry').newInstance(
          [refer('k'), typeArgument.toJson(refer('v'))],
          {},
          [refer('String'), refer('dynamic')]).code).closure;
    return e.nullSafeProperty('map').call([toMapEntryClosure]);
  }

  @override
  Expression fromParams(
      Expression fieldValue, Map<String, Reference> enumWireTypes) {
    if (typeArgument.canCastInCollection) {
      return fieldValue
          .asA(refer('Map'))
          .property('cast')
          .call([], {}, [refer('String'), typeArgument.type]);
    }
    final toMapEntryClosure = Method((b) => b
      ..lambda = true
      ..requiredParameters.add(Parameter((b) => b..name = 'k'))
      ..requiredParameters.add(Parameter((b) => b..name = 'v'))
      ..body = refer('MapEntry').newInstance([
        refer('k').asA(refer('String')),
        typeArgument.fromParams(refer('v'), enumWireTypes)
      ], {}, [
        refer('String'),
        typeArgument.type
      ]).code).closure;
    return fieldValue
        .asA(refer('Map'))
        .property('map')
        .call([toMapEntryClosure]);
  }

  @override
  Reference get type => TypeReference((b) => b
    ..symbol = 'Map'
    ..types.addAll([refer('String'), typeArgument.type]));

  @override
  bool get isPrimitive => typeArgument.isPrimitive;

  @override
  final canCastInCollection = false;

  @override
  Expression equalityCheck(String leftToken, String rightToken) =>
      refer('_deepEquals').call([refer(leftToken), refer(rightToken)]);
}
