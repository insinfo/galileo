import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';

/// Returns an Galileo service. Used within `package:galileo_toggle`.
typedef Service ServiceGenerator();

bool _isTestMode(Galileo app) {
  if (app.properties.containsKey('testMode'))
    return app.properties['testMode'] == true;
  return Platform.script.toString().toLowerCase().contains('test');
}

/// Mounts the [testModeService] at the given [path] if running in test mode. Otherwise, mounts the [defaultService].
///
/// If no [testModeService] is provided, it will default to a [MapService].
GalileoConfigurer toggleService(Pattern path, ServiceGenerator defaultService,
    [ServiceGenerator testModeService]) {
  return (Galileo app) async {
    if (_isTestMode(app)) {
      var service = testModeService != null
          ? testModeService()
          : new MapService();
      app.use(path, service);
      print('Galileo is running in test mode. Mounted $service at $path.');
    } else
      app.use(path, defaultService()); }; // Weird line ending to get 100% coverage...
}
