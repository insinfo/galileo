import 'dart:async';
import 'dart:io';
import 'package:galileo_container/mirrors.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:logging/logging.dart';

main() async {
  var app = Galileo(reflector: MirrorsReflector())
    ..logger = (Logger('galileo')
      ..onRecord.listen((rec) {
        print(rec);
        if (rec.error != null) print(rec.error);
        if (rec.stackTrace != null) print(rec.stackTrace);
      }))
    ..encoders.addAll({'gzip': gzip.encoder});

  app.fallback((req, res) => Future.error('Throwing just because I feel like!'));

  var http = GalileoHttp(app);
  var server = await http.startServer('127.0.0.1', 3000);
  var url = 'http://${server.address.address}:${server.port}';
  print('Listening at $url');
}
