import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildHashCode(String name, Iterable<MessageField> fields) {
  final base = name.hashCode;
  final skeleton = Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('int')
    ..type = MethodType.getter
    ..name = 'hashCode');
  if (fields.isEmpty) {
    return skeleton.rebuild((b) => b
      ..lambda = true
      ..body = literalNum(base).code);
  }
  final statements = <Code>[literalNum(base).assignVar('hash').statement];
  statements.addAll(fields.map((field) =>
      Code('hash = _hashCombine(hash, _deepHashCode(${field.name}));')));
  statements.add(Code('return _hashComplete(hash);'));
  return skeleton.rebuild((b) => b..body = Block.of(statements));
}
