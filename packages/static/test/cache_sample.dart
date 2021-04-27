import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

main() async {
  Galileo app;
  GalileoHttp http;
  Directory testDir = const LocalFileSystem().directory('test');
  app = Galileo();
  http = GalileoHttp(app);

  app.fallback(
    CachingVirtualDirectory(app, const LocalFileSystem(),
        source: testDir, maxAge: 350, onlyInProduction: false, indexFileNames: ['index.txt']).handleRequest,
  );

  app.get('*', (req, res) => 'Fallback');

  app.dumpTree(showMatchers: true);

  var server = await http.startServer();
  print('Open at http://${server.address.host}:${server.port}');
}
