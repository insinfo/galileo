class SomeMessage {
  SomeMessage._(this.intField, this.stringField);

  factory SomeMessage(void Function(SomeMessage$Builder) init) {
    final b = SomeMessage$Builder._();
    init(b);
    return SomeMessage._(b.intField, b.stringField);
  }

  factory SomeMessage.fromJson(Map params) => SomeMessage._(
      params.containsKey('intField') && params['intField'] != null
          ? (params['intField'] as int)
          : null,
      params.containsKey('stringField') && params['stringField'] != null
          ? (params['stringField'] as String)
          : null);

  final int intField;

  final String stringField;

  Map toJson() => {'intField': intField, 'stringField': stringField};
  @override
  int get hashCode {
    var hash = 530289568;
    hash = _hashCombine(hash, _deepHashCode(intField));
    hash = _hashCombine(hash, _deepHashCode(stringField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is SomeMessage &&
      intField == other.intField &&
      stringField == other.stringField;
}

class SomeMessage$Builder {
  SomeMessage$Builder._();

  int intField;

  String stringField;
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
