import 'dart:convert';
import 'package:angel_client/angel_client.dart';
import 'package:angel_client/flutter.dart';
import 'package:angel_websocket/flutter.dart';
import 'package:flutter/widgets.dart';

/// An [InheritedWidget] that manages an [Angel] client of some sort.
class AngelApp extends InheritedWidget {
  /// The [Angel] client.
  ///
  /// Typically [Rest] or [WebSockets].
  final Angel app;

  /// The [Widget] to draw.
  final Widget child;

  AngelApp({
    @required this.app,
    @required this.child,
  });

  /// Casts [app] to [Rest].
  Rest get asRest => app as Rest;

  /// Casts [app] to [WebSockets].
  WebSockets get asWebSockets => app as WebSockets;

  static AngelApp of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AngelApp) as AngelApp;
  }

  /// Returns a [Service] that queries a path on the server.
  ///
  /// This is closely-related to server-side Angel `Service`s, which
  /// automatically maps to RESTful endpoints.
  Service<String, Map<String, dynamic>> service(String path) {
    return app.service<String, Map<String, dynamic>>(path);
  }

  /// Uses [encoder] and [decoder] to map a [service] into concrete Dart objects.
  Service<String, T> typedService<T>(
      String path,
      T Function(Map<String, dynamic>) encoder,
      Map<String, dynamic> Function(T) decoder) {
    return service(path).map(encoder, decoder);
  }

  /// Uses the [codec] to (de)serialize objects in a [typedService].
  Service<String, T> typedServiceVia<T>(String path, Codec<T, Map> codec) {
    return service(path)
        .map(codec.decode, (m) => codec.encode(m).cast<String, dynamic>());
  }

  @override
  bool updateShouldNotify(AngelApp oldWidget) {
    return app != oldWidget.app || child != oldWidget.child;
  }
}
