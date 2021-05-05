Relational modeling is one of the most commonly-used features of sql databases -
after all, it *is* the namesake of the term "relational database."

Galileo supports the following kinds of relations by means of annotations on fields:
* `@hasOne` (one-to-one)
* `@hasMany` (one-to-many)
* `@belongsTo` (one-to-one)
* `@manyToMany` (many-to-many)

By default, the keys for columns are inferred automatically.
In the following case:

```dart
@orm
@serializable
abstract class _Wheel extends Model {
  @belongsTo
  Car get car;
}
```

The local key defaults to `car_id`, and the foreign key defaults to `id`.
You can manually override these:

```dart
@BelongsTo(localKey: 'carId', foreignKey: 'licenseNumber')
Car get car;
```

The ORM computes relationships by performing `JOIN`s, so that even complex
relationships can be fetched using just one query, rather than multiple.

## Many-to-many Relationships
A very common situation that occurs when using relational databases is where two tables
may be bound to multiple copies of each other. For example, in a school database, each student
could be registered to multiple classes, and each class could have multiple students taking it.

This is typically handled by creating a third table, which joins the two together.
In the Galileo ORM, this is relatively straightforward:

```dart
@orm
@serializable
abstract class _Class extends Model {
  String get courseName;

  @ManyToMany(_Enrollment)
  List<_Student> get students;
}

@orm
@serializable
abstract class _Student extends Model  {
  String get name;
  int get year;

  @ManyToMany(_Enrollment)
  List<_Class> get classes;
}

@orm
@serializable
abstract class _Enrollment {
    @belongsTo
    _Student get student;

    @belongsTo
    _Class get class_;
}
```
