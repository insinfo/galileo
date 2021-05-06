import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:galileo_wings/galileo_wings.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';
import 'package:galileo_pretty_logging/galileo_pretty_logging.dart';

main() async {
  hierarchicalLoggingEnabled = true;

  var logger = Logger.detached('wings')
    ..level = Level.ALL
    ..onRecord.listen(prettyLog);
  var app = Galileo(logger: logger);
  var wings = GalileoWings(app);
  var fs = LocalFileSystem();
  var vDir = CachingVirtualDirectory(app, fs, source: fs.currentDirectory, allowDirectoryListing: true);

  app.mimeTypeResolver.addExtension('yaml', 'text/x-yaml');

  app.get('/', (req, res) => 'WINGS!!!');
  app.post('/', (req, res) async {
    await req.parseBody();
    return req.bodyAsMap;
  });

  app.fallback(vDir.handleRequest);
  app.fallback((req, res) => throw GalileoHttpException.notFound());

  await wings.startServer(InternetAddress.loopbackIPv4, 3000);
  print('Listening at ${wings.uri}');
}
