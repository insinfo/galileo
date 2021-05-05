import 'dart:async';
import 'package:galileo_client/galileo_client.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'galileo_app.dart';

/// Launches [url] in a WebView, and waits until the app receives
/// a URL with the given [scheme].
///
/// The received token is then revived. This function can be used
/// to easily log users in.
///
/// If [useSharedPreferences] is `true` (default), then it will first attempt
/// to see if there is already an existing, persisted token.
Future<GalileoAuthResult> showAuthPopupAndReviveToken(
    {@required String scheme,
    @required Uri url,
    bool useSharedPreferences = true,
    BuildContext context,
    Galileo app,
    String authEndpoint = '/auth'}) {
  app ??= GalileoApp.of(context).app;
  return showAuthPopup(scheme: scheme, url: url).then((token) {
    return app.reviveJwt(token, authEndpoint: authEndpoint).then((auth) async {
      if (useSharedPreferences) {
        var prefs = await SharedPreferences.getInstance();
        await prefs.setString('galileo_auth_token', auth.token);
      }

      return auth;
    }).catchError((e, st) async {
      var prefs = await SharedPreferences.getInstance();
      await prefs.setString('galileo_auth_token', null);
      throw e;
    });
  });
}

/// Launches [url] in a WebView, and waits until the app receives
/// a URL with the given [scheme].
///
/// The server at [url] must return a redirect with [scheme] of course.
///
/// If [useSharedPreferences] is `true` (default), then it will first attempt
/// to see if there is already an existing, persisted token.
Future<String> showAuthPopup({
  @required String scheme,
  @required Uri url,
  bool useSharedPreferences = true,
}) {
  var c = Completer<String>();
  StreamSubscription<Uri> _sub;

  void onData(Uri uri) {
    if (uri?.scheme == scheme && uri.queryParameters.containsKey('token') && !c.isCompleted) {
      var token = uri.queryParameters['token'];
      c.complete(token);
    }
  }

  Future<String> checkPrefs;

  if (!useSharedPreferences) {
    checkPrefs = Future.value();
  } else {
    checkPrefs = SharedPreferences.getInstance().then((prefs) {
      return prefs.getString('galileo_auth_token');
    }).catchError((_) => null);
  }

  return checkPrefs.then((existing) {
    if (existing != null) return existing;
    getInitialUri().then(onData);
    _sub = getUriLinksStream().listen(onData);

    canLaunch(url.toString()).then((can) {
      if (!can) {
        launch(url.toString(), forceWebView: true, forceSafariVC: true);
      } else if (!c.isCompleted) {
        c.completeError(UnsupportedError('Cannot launch authentication popup at $url.'));
      }
    });

    return c.future.whenComplete(() => _sub?.cancel());
  });
}
