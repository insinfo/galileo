abstract class ParentMessage {
  factory ParentMessage.fromJson(Map params) {
    final selectBy = params['selectField'];
    if (selectBy == 'firstValue') return FirstChildMessage.fromJson(params);
    if (selectBy == 'secondValue') return SecondChildMessage.fromJson(params);
    if (selectBy == 'thirdValue') return ThirdChildMessage.fromJson(params);
    throw ArgumentError('Could not match ParentMessage for $selectBy');
  }

  Map toJson();
}

class FirstChildMessage implements ParentMessage {
  FirstChildMessage._(this.firstField);

  factory FirstChildMessage(void Function(FirstChildMessage$Builder) init) {
    final b = FirstChildMessage$Builder._();
    init(b);
    return FirstChildMessage._(b.firstField);
  }

  factory FirstChildMessage.fromJson(Map params) => FirstChildMessage._(
      params.containsKey('firstField') && params['firstField'] != null
          ? (params['firstField'] as int)
          : null);

  final int firstField;

  final selectField = 'firstValue';

  @override
  Map toJson() => {'firstField': firstField, 'selectField': 'firstValue'};
  @override
  int get hashCode {
    var hash = 307866602;
    hash = _hashCombine(hash, _deepHashCode(firstField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is FirstChildMessage && firstField == other.firstField;
}

class FirstChildMessage$Builder {
  FirstChildMessage$Builder._();

  int firstField;
}

class SecondChildMessage implements ParentMessage {
  SecondChildMessage._(this.secondField);

  factory SecondChildMessage(void Function(SecondChildMessage$Builder) init) {
    final b = SecondChildMessage$Builder._();
    init(b);
    return SecondChildMessage._(b.secondField);
  }

  factory SecondChildMessage.fromJson(Map params) => SecondChildMessage._(
      params.containsKey('secondField') && params['secondField'] != null
          ? (params['secondField'] as String)
          : null);

  final String secondField;

  final selectField = 'secondValue';

  @override
  Map toJson() => {'secondField': secondField, 'selectField': 'secondValue'};
  @override
  int get hashCode {
    var hash = 34131136;
    hash = _hashCombine(hash, _deepHashCode(secondField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is SecondChildMessage && secondField == other.secondField;
}

class SecondChildMessage$Builder {
  SecondChildMessage$Builder._();

  String secondField;
}

class ThirdChildMessage implements ParentMessage {
  const ThirdChildMessage();

  const ThirdChildMessage.fromJson([_]);

  final selectField = 'thirdValue';

  @override
  Map toJson() => {'selectField': 'thirdValue'};
  @override
  int get hashCode => 560423767;
  @override
  bool operator ==(Object other) => other is ThirdChildMessage;
}

class ThirdChildMessage$Builder {
  ThirdChildMessage$Builder._();
}

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
