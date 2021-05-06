import 'package:galileo_cache/galileo_cache.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';

main() async {
  var app = Galileo();

  app.use(
    '/api/todos',
    CacheService(
      cache: MapService(),
      database: AnonymousService(index: ([params]) {
        print(
            'Fetched directly from the underlying service at ${new DateTime.now()}!');
        return ['foo', 'bar', 'baz'];
      }, read: (id, [params]) {
        return {id: '$id at ${new DateTime.now()}'};
      }),
    ),
  );

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
