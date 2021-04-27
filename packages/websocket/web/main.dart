import 'dart:html';
import 'package:galileo_websocket/browser.dart';

/// Dummy app to ensure client works with DDC.
main() {
  var app = WebSockets(window.location.origin);
  window.alert(app.baseUrl.toString());

  app.connect().catchError((_) {
    window.alert('no websocket');
  });
}
