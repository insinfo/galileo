// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bar.dart';

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Bar extends _Bar {
  Bar({this.id, this.foo, this.description, this.createdAt, this.updatedAt});

  @override
  final String id;

  @override
  final Foo foo;

  @override
  final String description;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Bar copyWith(
      {String id,
      Foo foo,
      String description,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Bar(
        id: id ?? this.id,
        foo: foo ?? this.foo,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Bar &&
        other.id == id &&
        other.foo == foo &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, foo, description, createdAt, updatedAt]);
  }

  Map<String, dynamic> toJson() {
    return BarSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class BarSerializer {
  static Bar fromMap(Map map) {
    return new Bar(
        id: map['id'] as String,
        foo: map['foo'] != null
            ? FooSerializer.fromMap(map['foo'] as Map)
            : null,
        description: map['description'] as String,
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

  static Map<String, dynamic> toMap(_Bar model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'foo': FooSerializer.toMap(model.foo),
      'description': model.description,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class BarFields {
  static const List<String> allFields = const <String>[
    id,
    foo,
    description,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String foo = 'foo';

  static const String description = 'description';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
