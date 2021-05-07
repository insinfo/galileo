class InnerMessage {
  InnerMessage._(this.anotherField);

  factory InnerMessage(void Function(InnerMessage$Builder) init) {
    final b = InnerMessage$Builder._();
    init(b);
    return InnerMessage._(b.anotherField);
  }

  factory InnerMessage.fromJson(Map params) => InnerMessage._(
      params.containsKey('anotherField') && params['anotherField'] != null
          ? (params['anotherField'] as String)
          : null);

  final String anotherField;

  Map toJson() => {'anotherField': anotherField};
  @override
  int get hashCode {
    var hash = 407157155;
    hash = _hashCombine(hash, _deepHashCode(anotherField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is InnerMessage && anotherField == other.anotherField;
}

class InnerMessage$Builder {
  InnerMessage$Builder._();

  String anotherField;
}

class OuterMessage {
  OuterMessage._(this.innerField, this.stringField);

  factory OuterMessage(void Function(OuterMessage$Builder) init) {
    final b = OuterMessage$Builder._();
    init(b);
    return OuterMessage._(b.innerField, b.stringField);
  }

  factory OuterMessage.fromJson(Map params) => OuterMessage._(
      params.containsKey('innerField') && params['innerField'] != null
          ? InnerMessage.fromJson((params['innerField'] as Map))
          : null,
      params.containsKey('stringField') && params['stringField'] != null
          ? (params['stringField'] as String)
          : null);

  final InnerMessage innerField;

  final String stringField;

  Map toJson() =>
      {'innerField': innerField?.toJson(), 'stringField': stringField};
  @override
  int get hashCode {
    var hash = 556777058;
    hash = _hashCombine(hash, _deepHashCode(innerField));
    hash = _hashCombine(hash, _deepHashCode(stringField));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is OuterMessage &&
      innerField == other.innerField &&
      stringField == other.stringField;
}

class OuterMessage$Builder {
  OuterMessage$Builder._();

  InnerMessage innerField;

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
