import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';

/// A [Service] that fetches data from a SQL database, and returns [List]s.
///
/// These [List] objects are, more often than not, mapped into Dart objects.
abstract class SqlService<Id, Data> extends Service<Id, Data> {
  /// A [Function] that turns a [Data] object into
  /// a set of substitution values that can be injected into a query.
  final Map<String, dynamic> Function(Data) encoder;

  /// A [Function] that deserializes a SQL row into a [Data] object.
  final Data Function(List) decoder;

  /// The name of the database table that this service will query.
  final String tableName;

  /// A whitelist of query fields that can be substituted into queries.
  ///
  /// Any client-side field requested that is not within this list is ignored.
  final Iterable<String> fields;

  /// If set to `true`, parameters in `req.query` are applied to the database query.
  final bool allowQuery;

  /// If set to `true`, clients can remove all items by passing a `null` `id` to `remove`.
  ///
  /// `false` by default.
  final bool allowRemoveAll;

  SqlService(this.encoder, this.decoder, this.tableName, this.fields,
      {this.allowQuery, this.allowRemoveAll});

  /// The joined list of [fields] that is placed into every query.
  String get fieldSet => _fieldSet ??= fields.join(', ');
  String _fieldSet;

  /// Executes a SQL query, and returns a single row.
  FutureOr<List> row(String fmtString, Map<String, dynamic> substitutionValues);

  /// Executes a SQL query, and returns multiple rows.
  FutureOr<List<List>> rows(
      String fmtString, Map<String, dynamic> substitutionValues);

  /// Converts an [id] into an [int], so that it can be injected as an ID into a SQL query.
  int convertId(Id id) => int.parse(id.toString());

  @override
  Future<Data> findOne(
      [Map<String, dynamic> params,
      String errorMessage = 'No record was found matching the given query.']) {
    // TODO: implement findOne
    return super.findOne(params, errorMessage);
  }

  @override
  Future<List<Data>> index([Map<String, dynamic> params]) {
    // TODO: implement index
    return new Future.sync(() {
      return rows('SELECT $fieldSet FROM $tableName;', {});
    }).then((rows) {
      return rows.map(decoder).toList();
    });
  }

  @override
  Future<Data> read(Id id, [Map<String, dynamic> params]) {
    var query = 'SELECT $fieldSet FROM $tableName WHERE id = @id LIMIT 1;';
    return new Future.sync(() {
      return row(query, {'id': convertId(id)});
    }).then((row) {
      if (row == null)
        throw new GalileoHttpException.notFound(
            message: 'No record found for ID $id');
      return decoder(row);
    });
  }

  @override
  Future<List<Data>> readMany(List<Id> ids, [Map<String, dynamic> params]) {
    var idSet = ids.join(', ');
    var query = 'SELECT $fieldSet FROM $tableName WHERE id IN $idSet;';
    return new Future.sync(() {
      return rows(query, {});
    }).then((l) => l.map(decoder).toList());
  }

  @override
  Future<Data> create(Data data, [Map<String, dynamic> params]) {
    // TODO: implement create
    return super.create(data, params);
  }

  @override
  Future<Data> modify(Id id, Data data, [Map<String, dynamic> params]) {
    // TODO: implement modify
    return super.modify(id, data, params);
  }

  @override
  Future<Data> update(Id id, Data data, [Map<String, dynamic> params]) {
    // TODO: implement update
    return super.update(id, data, params);
  }

  @override
  Future<Data> remove(Id id, [Map<String, dynamic> params]) {
    // TODO: removeAll
    var query =
        'DELETE FROM $tableName WHERE id = @id LIMIT 1 RETURNING ($fieldSet);';
    return new Future.sync(() {
      return row(query, {'id': convertId(id)});
    }).then(decoder);
  }
}
