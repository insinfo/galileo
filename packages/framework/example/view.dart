import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';

main() async {
  var app = Galileo(reflector: MirrorsReflector());

  app.viewGenerator = (name, [data]) async => 'View generator invoked with name $name and data: $data';

  // Index route. Returns JSON.
  app.get('/', (req, res) => res.render('index', {'foo': 'bar'}));

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  var url = 'http://${server.address.address}:${server.port}';
  print('Listening at $url');
}
