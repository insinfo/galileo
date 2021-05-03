import 'package:angel_framework/angel_framework.dart';

/// Runs a [callback] on every service, and listens for future services to run it again.
AngelConfigurer hookAllServices(callback(Service service)) {
  return (Angel app) {
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
