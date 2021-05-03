export 'src/sql_service.dart';

/// Returns a simple decoder that parses a row ([List]) into a [Map], by reading [fields] from it.
Map<String, dynamic> Function(List) parseRowFromFields(List<String> fields) {
  return (row) {
    if (row == null) return null;
    return new Map.fromEntries(List.generate(fields.length,
        (i) => new MapEntry(fields[i], row.length <= i ? null : row[i])));
  };
}
