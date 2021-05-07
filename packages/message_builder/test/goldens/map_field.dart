class AnotherMessage {
  AnotherMessage._(this.innerMessageMap);

  factory AnotherMessage(void Function(AnotherMessage$Builder) init) {
    final b = AnotherMessage$Builder._();
    init(b);
    return AnotherMessage._(b.innerMessageMap);
  }

  factory AnotherMessage.fromJson(Map params) => AnotherMessage._(
      params.containsKey('innerMessageMap') && params['innerMessageMap'] != null
          ? (params['innerMessageMap'] as Map).cast<String, String>()
          : null);

  final Map<String, String> innerMessageMap;

  Map toJson() => {'innerMessageMap': innerMessageMap};
  @override
  int get hashCode {
    var hash = 170180962;
    hash = _hashCombine(hash, _deepHashCode(innerMessageMap));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is AnotherMessage &&
      _deepEquals(innerMessageMap, other.innerMessageMap);
}

class AnotherMessage$Builder {
  AnotherMessage$Builder._();

  Map<String, String> innerMessageMap;
}

class SomeMapMessage {
  SomeMapMessage._(this.intMap, this.listMap, this.mapMap, this.messageMap);

  factory SomeMapMessage(void Function(SomeMapMessage$Builder) init) {
    final b = SomeMapMessage$Builder._();
    init(b);
    return SomeMapMessage._(b.intMap, b.listMap, b.mapMap, b.messageMap);
  }

  factory SomeMapMessage.fromJson(Map params) => SomeMapMessage._(
      params.containsKey('intMap') && params['intMap'] != null
          ? (params['intMap'] as Map).cast<String, int>()
          : null,
      params.containsKey('listMap') && params['listMap'] != null
          ? (params['listMap'] as Map).map((k, v) =>
              MapEntry<String, List<int>>(
                  (k as String), (v as List).cast<int>()))
          : null,
      params.containsKey('mapMap') && params['mapMap'] != null
          ? (params['mapMap'] as Map).map((k, v) =>
              MapEntry<String, Map<String, String>>(
                  (k as String), (v as Map).cast<String, String>()))
          : null,
      params.containsKey('messageMap') && params['messageMap'] != null
          ? (params['messageMap'] as Map).map((k, v) =>
              MapEntry<String, AnotherMessage>(
                  (k as String), AnotherMessage.fromJson((v as Map))))
          : null);

  final Map<String, int> intMap;

  final Map<String, List<int>> listMap;

  final Map<String, Map<String, String>> mapMap;

  final Map<String, AnotherMessage> messageMap;

  Map toJson() => {
        'intMap': intMap,
        'listMap': listMap,
        'mapMap': mapMap,
        'messageMap':
            messageMap?.map((k, v) => MapEntry<String, dynamic>(k, v?.toJson()))
      };
  @override
  int get hashCode {
    var hash = 1073311120;
    hash = _hashCombine(hash, _deepHashCode(intMap));
    hash = _hashCombine(hash, _deepHashCode(listMap));
    hash = _hashCombine(hash, _deepHashCode(mapMap));
    hash = _hashCombine(hash, _deepHashCode(messageMap));
    return _hashComplete(hash);
  }

  @override
  bool operator ==(Object other) =>
      other is SomeMapMessage &&
      _deepEquals(intMap, other.intMap) &&
      _deepEquals(listMap, other.listMap) &&
      _deepEquals(mapMap, other.mapMap) &&
      _deepEquals(messageMap, other.messageMap);
}

class SomeMapMessage$Builder {
  SomeMapMessage$Builder._();

  Map<String, int> intMap;

  Map<String, List<int>> listMap;

  Map<String, Map<String, String>> mapMap;

  Map<String, AnotherMessage> messageMap;
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
