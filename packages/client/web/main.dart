import 'dart:html';
import 'package:galileo_client/browser.dart';

/// Dummy app to ensure client works with DDC.
main() {
  var app = Rest(window.location.origin);
  window.alert(app.baseUrl.toString());
}
