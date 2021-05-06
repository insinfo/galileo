import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_user_agent/galileo_user_agent.dart';

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);

  // TODO: Commented out due to unknow class
  /*
  app.get(
    '/',
    waterfall([
      parseUserAgent,
      (req, res) {
        var ua = req.container.make<UserAgent>();
        return ua.isChrome
            ? 'Woohoo! You are running Chrome.'
            : 'Sorry, we only support Google Chrome.';
      },
    ]),
  );
  */

  var server = await http.startServer(InternetAddress.anyIPv4, 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
