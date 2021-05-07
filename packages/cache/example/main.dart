import 'package:galileo_cache/galileo_cache.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:glob/glob.dart';

main() async {
  var app = Galileo();

  // Cache a glob
  var cache = ResponseCache()
    ..patterns.addAll([
      Glob('/*.txt'),
    ]);

  // Handle `if-modified-since` header, and also send cached content
  app.all('*', cache.handleRequest);

  // A simple handler that returns a different result every time.
  app.get('/date.txt', (req, res) => res.write('2021-05-07T11:07:58.616014' /*DateTime.now().toIso8601String() */));

  // Support purging the cache.
  app.addRoute('PURGE', '*', (req, res) {
    if (req.ip != '127.0.0.1') throw GalileoHttpException.forbidden();

    cache.purge(req.uri.path);
    print('Purged ${req.uri.path}');
  });

  // The response finalizer that actually saves the content
  app.responseFinalizers.add(cache.responseFinalizer);

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
