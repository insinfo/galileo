library angel;

import 'dart:async';
import 'dart:io';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/server.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:postgres/postgres.dart';
import 'src/models/user.orm.g.dart';

const FileSystem fs = const LocalFileSystem();

/// Configures an Angel server.
Future configureServer(Angel app) async {
  // Loads app configuration from 'config/'.
  // It supports loading from YAML files, and also supports loading a `.env` file.
  //
  // https://github.com/angel-dart/configuration
  await app.configure(configuration(fs));

  // All loaded configuration will be added to `app.configuration`.
  print('Loaded configuration: ${app.configuration}');

  // Let's create a simple PostgreSQL connection pool. We can plug this into our
  // dependency injection system, so that we can connect with the same credentials
  // from anywhere.
  Map postgresConfig = app.configuration['postgres'];
  var pool = new PostgreSQLConnectionPool(() => new PostgreSQLConnection(
      postgresConfig['host'],
      postgresConfig['port'],
      postgresConfig['database'],
      username: postgresConfig['username'],
      password: postgresConfig['password']));
  app.container.singleton(pool);

  // This is a simple route.
  //
  // Read more about routing and request handling:
  // * https://github.com/angel-dart/angel/wiki/Basic-Routing
  // * https://github.com/angel-dart/angel/wiki/Requests-&-Responses
  // * https://github.com/angel-dart/angel/wiki/Request-Lifecycle
  app.get('/greet/:name', (String name) => 'Hello, $name!');

  // A simple route that fetches all users.
  app.get(
      '/users',
      // Our connection pool is dependency injected. We could place this route
      // anywhere in our project, and it would run the same.
      (PostgreSQLConnectionPool pool) =>
          pool.run((connection) => UserQuery.getAll(connection)));

  // Sets up a static server (with caching support).
  // Defaults to serving out of 'web/'.
  // In production mode, it'll try to serve out of `build/web/`.
  //
  // https://github.com/angel-dart/static
  var vDir = new CachingVirtualDirectory(app, fs);
  app.use(vDir.handleRequest);

  // This route will only run if the request was not terminated by a prior handler.
  // This is a situation in which you'll want to throw a 404 error.
  // On 404's, let's redirect the user to a pretty error page.
  app.use((ResponseContext res) => res.redirect('/not-found.html'));

  // Enable GZIP and DEFLATE compression (conserves bandwidth)
  app.injectEncoders({
    'gzip': GZIP.encoder,
    'deflate': ZLIB.encoder,
  });
}
