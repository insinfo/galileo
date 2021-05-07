class SomeListMessage {
  SomeListMessage._(this.intList, this.stringList);

  factory SomeListMessage(void Function(SomeListMessage$Builder) init) {
    final b = SomeListMessage$Builder._();
    init(b);
    return SomeListMessage._(b.intList, b.stringList);
  }

  factory SomeListMessage.fromJson(Map params) => SomeListMessage._(
      params.containsKey('intList') && params['intList'] != null
          ? (params['intList'] as List).cast<int>()
          : null,
      params.containsKey('stringList') && params['stringList'] != null
          ? (params['stringList'] as List).cast<String>()
          : null);

  final List<int> intList;

  final List<String> stringList;

  Map toJson() => {'intList': intList, 'stringList': stringList};
  @override
  int get hashCode {
    var hash = 530163;
    hash = _hashCombine(hash, _deepHashCode(intList));
    hash = _hashCombine(hash, _deepHashCode(stringList));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is SomeListMessage &&
      _deepEquals(intList, other.intList) &&
      _deepEquals(stringList, other.stringList);
}

class SomeListMessage$Builder {
  SomeListMessage$Builder._();

  List<int> intList;

  List<String> stringList;
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

bool _deepEquals(dynamic left, dynamic right) {
  if (left is List && right is List) {
    final leftLength = left.length;
    final rightLength = right.length;
    if (leftLength != rightLength) return false;
    for (var i = 0; i < leftLength; i++) {
      if (!_deepEquals(left[i], right[i])) return false;
    }
    return true;
  }
  if (left is Map && right is Map) {
    final leftLength = left.length;
    final rightLength = right.length;
    if (leftLength != rightLength) return false;
    for (final key in left.keys) {
      if (!_deepEquals(left[key], right[key])) return false;
    }
    return true;
  }
  return left == right;
}
