import 'dart:convert';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_seo/galileo_seo.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/local.dart';
import 'package:http_parser/http_parser.dart';

main() async {
  var app = new Galileo();
  var fs = const LocalFileSystem();
  var http = new GalileoHttp(app);

  // You can wrap a [VirtualDirectory]
  var vDir = inlineAssetsFromVirtualDirectory(
    new VirtualDirectory(
      app,
      fs,
      source: fs.directory('web'),
    ),
  );

  app.fallback(vDir.handleRequest);

  // OR, just add a finalizer. Note that [VirtualDirectory] *streams* its response,
  // so a response finalizer does not touch its contents.
  //
  // You likely won't need to use both; it just depends on your use case.
  app.responseFinalizers.add(inlineAssets(fs.directory('web')));

  app.get('/using_response_buffer', (req, res) async {
    var indexHtml = fs.directory('web').childFile('index.html');
    var contents = await indexHtml.readAsString();
    res
      ..contentType = new MediaType('text', 'html', {'charset': 'utf-8'})
      ..buffer.add(utf8.encode(contents));
  });

  app.fallback((req, res) => throw new GalileoHttpException.notFound());

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
