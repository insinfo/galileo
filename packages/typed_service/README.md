# typed_service
Galileo services that use reflection (via mirrors or codegen) to (de)serialize PODO's.
Useful for quick prototypes.

Typically, [`package:galileo_serialize`](https://github.com/galileo-dart/serialize)
is recommended.

## Brief Example
```dart
main() async {
  var app = Galileo();
  var http = GalileoHttp(app);
  var service = TypedService<String, Todo>(MapService());
  hierarchicalLoggingEnabled = true;
  app.use('/api/todos', service);

  app
    ..serializer = god.serialize
    ..logger = Logger.detached('typed_service')
    ..logger.onRecord.listen((rec) {
      print(rec);
      if (rec.error != null) print(rec.error);
      if (rec.stackTrace != null) print(rec.stackTrace);
    });

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
```
