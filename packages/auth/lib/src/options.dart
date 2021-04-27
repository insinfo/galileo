import 'dart:async';

import 'package:galileo_framework/galileo_framework.dart';
import 'auth_token.dart';

typedef FutureOr GalileoAuthCallback(RequestContext req, ResponseContext res, String token);

typedef FutureOr GalileoAuthTokenCallback<User>(RequestContext req, ResponseContext res, AuthToken token, User user);

class GalileoAuthOptions<User> {
  GalileoAuthCallback callback;
  GalileoAuthTokenCallback<User> tokenCallback;
  String successRedirect;
  String failureRedirect;

  /// If `false` (default: `true`), then successful authentication will return `true` and allow the
  /// execution of subsequent handlers, just like any other middleware.
  ///
  /// Works well with `Basic` authentication.
  bool canRespondWithJson;

  GalileoAuthOptions(
      {this.callback,
      this.tokenCallback,
      this.canRespondWithJson = true,
      this.successRedirect,
      String this.failureRedirect});
}
