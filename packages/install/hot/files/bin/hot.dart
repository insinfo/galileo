import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_hot/galileo_hot.dart';
import 'package:{{ project_name }}/{{ project_name }}.dart';

/// Auto-reloads the server on file changes.
main() async {
  var hot = new HotReloader(() async {
    var app = new Galileo()..lazyParseBodies = true;
    await app.configure(configureServer);
    return app;
  }, [
    new Directory('config'),
    new Directory('lib'),
  ]);
}
