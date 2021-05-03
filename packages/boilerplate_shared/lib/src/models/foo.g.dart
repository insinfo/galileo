// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foo.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Foo extends _Foo {
  Foo({this.id, this.text, this.number, this.createdAt, this.updatedAt});

  @override
  final String id;

  @override
  final String text;

  @override
  final int number;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Foo copyWith(
      {String id,
      String text,
      int number,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Foo(
        id: id ?? this.id,
        text: text ?? this.text,
        number: number ?? this.number,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Foo &&
        other.id == id &&
        other.text == text &&
        other.number == number &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, text, number, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return FooSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class FooSerializer {
  static Foo fromMap(Map map) {
    return new Foo(
        id: map['id'] as String,
        text: map['text'] as String,
        number: map['number'] as int,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_Foo model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'text': model.text,
      'number': model.number,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class FooFields {
  static const List<String> allFields = const <String>[
    id,
    text,
    number,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String text = 'text';

  static const String number = 'number';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
