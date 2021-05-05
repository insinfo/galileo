PostgreSQL support is provided by way of `package:galileo_orm_postgres`.
The `PostgreSQLExecutor` implements `QueryExecutor`, and takes care of
running prepared queries, and passing values to the database server.

`galileo init` projects using the ORM include helpers like this to load app
configuration into a database connection:

```dart
Future<void> configureServer(Galileo app) async {
  var connection = await connectToPostgres(app.configuration);
  await connection.open();

  app
    ..container.registerSingleton<QueryExecutor>(PostgreSQLExecutor(connection))
    ..shutdownHooks.add((_) => connection.close());
}

Future<PostgreSQLConnection> connectToPostgres(Map configuration) async {
  var postgresConfig = configuration['postgres'] as Map ?? {};
  var connection = PostgreSQLConnection(
      postgresConfig['host'] as String ?? 'localhost',
      postgresConfig['port'] as int ?? 5432,
      postgresConfig['database_name'] as String ??
          Platform.environment['USER'] ??
          Platform.environment['USERNAME'],
      username: postgresConfig['username'] as String,
      password: postgresConfig['password'] as String,
      timeZone: postgresConfig['time_zone'] as String ?? 'UTC',
      timeoutInSeconds: postgresConfig['timeout_in_seconds'] as int ?? 30,
      useSSL: postgresConfig['use_ssl'] as bool ?? false);
  return connection;
```

Typically, you'll want to use app configuration to create the connection,
rather than hard coding values.
