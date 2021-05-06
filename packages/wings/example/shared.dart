import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_wings/galileo_wings.dart';

main() async {
  var app = Galileo();
  var wings1 = GalileoWings.custom(app, startSharedWings);
  var wings2 = GalileoWings.custom(app, startSharedWings);
  var wings3 = GalileoWings.custom(app, startSharedWings);
  var wings4 = GalileoWings.custom(app, startSharedWings);
  await wings1.startServer('127.0.0.1', 3000);
  await wings2.startServer('127.0.0.1', 3000);
  await wings3.startServer('127.0.0.1', 3000);
  await wings4.startServer('127.0.0.1', 3000);
  print(wings1.uri);
  print(wings2.uri);
  print(wings3.uri);
  print(wings4.uri);
  await wings1.close();
  await wings2.close();
  await wings3.close();
  await wings4.close();
}
