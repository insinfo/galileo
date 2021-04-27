import 'dart:async';

import 'package:galileo_configuration/galileo_configuration.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:file/local.dart';

Future<void> main() async {
  var app = Galileo();
  var fs = const LocalFileSystem();
  await app.configure(configuration(fs));
}
