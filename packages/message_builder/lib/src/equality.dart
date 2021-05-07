import 'package:code_builder/code_builder.dart';

import 'fields.dart';

Method buildEquals(String clazz, Iterable<MessageField> fields) {
  var equality = refer('other').isA(refer(clazz));
  for (final field in fields) {
    equality = equality.and(field.equalityCheck('other'));
  }
  return Method((b) => b
    ..annotations.add(refer('override'))
    ..returns = refer('bool')
    ..name = 'operator=='
    ..requiredParameters.add((Parameter((b) => b
      ..type = refer('Object')
      ..name = 'other')))
    ..lambda = true
    ..body = equality.code);
}
