import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_production/galileo_production.dart';
import 'package:galileo_proxy/galileo_proxy.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/local.dart';
import 'package:http/io_client.dart' as http;

main(List<String> args) => Runner('examples-v2', configureServer).run(args);

Future configureServer(Galileo app) async {
  // In development, proxy to localhost:8080 (pub serve).
  //
  // The proxy also supports WebSockets, so it works with webpack-dev-server, etc.
  if (!app.isProduction) {
    var proxy = Proxy(
      http.IOClient(),
      Uri.parse('http://localhost:8080'),
      recoverFrom404: false,
      recoverFromDead: false,
    );

    app
      ..fallback(proxy.handleRequest)
      ..shutdownHooks.add((_) => proxy.close());
  } else {
    // In production, serve files from build/web.
    var fs = LocalFileSystem();
    var vDir = VirtualDirectory(app, fs, source: fs.directory('build/web'));
    app.fallback(vDir.handleRequest);
  }

  // Throw a 404 if no route was matched.
  app.fallback((req, res) => throw GalileoHttpException.notFound());
}
