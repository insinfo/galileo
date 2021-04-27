import 'dart:io';
import 'package:galileo_hot/galileo_hot.dart';
import 'server.dart';

main() async {
  var hot = HotReloader(createServer, [
    Directory('src'),
    'server.dart',
    // Also allowed: Platform.script,
    Uri.parse('package:galileo_hot/galileo_hot.dart')
  ]);
  await hot.startServer('127.0.0.1', 3000);
}
