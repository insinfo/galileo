import 'package:galileo_framework/galileo_framework.dart';

/// Runs a [callback] on every service, and listens for future services to run it again.
GalileoConfigurer hookAllServices(callback(Service service)) {
  return (Galileo app) {
    var touched = <Service>[];

    for (var service in app.services.values) {
      if (!touched.contains(service)) {
        callback(service);
        touched.add(service);
      }
    }

    app.onService.listen((service) {
      if (!touched.contains(service)) return callback(service);
    });
  };
}
