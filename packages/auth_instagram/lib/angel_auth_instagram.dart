import 'dart:async';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:http/http.dart' as http;
import 'package:instagram/instagram.dart';

/// Authenticates a user using information from the Instagram API.
typedef InstagramAuthVerifier(InstagramApi client);

/// Generates a `state` string to be forwarded to Instagram.
typedef FutureOr<String> InstagramStateGenerator(
    RequestContext req, ResponseContext res);

class InstagramAuthStrategy extends AuthStrategy {
  Uri _redirectUri;
  final InstagramApiAuth instagramAuth;
  final InstagramAuthVerifier verifier;
  final InstagramStateGenerator stateGenerator;

  InstagramAuthStrategy(this.instagramAuth, this.verifier,
      {this.stateGenerator});

  @override
  Future<bool> canLogout(RequestContext req, ResponseContext res) =>
      new Future<bool>.value(true);

  @override
  Future authenticate(RequestContext req, ResponseContext res,
      [GalileoAuthOptions options]) {
    if (options != null) return authenticateCallback(req, res, options);
    return new Future.sync(() {
      if (stateGenerator == null)
        return null;
      else
        return stateGenerator(req, res);
    }).then((state) {
      var url = instagramAuth.getRedirectUri(state: state);
      res.redirect(url.toString());
      return false;
    });
  }

  Future authenticateCallback(
      RequestContext req, ResponseContext res, GalileoAuthOptions options) async {
    if (!req.query.containsKey('code'))
      throw new GalileoHttpException.badRequest(
          message: 'Expected "code" in query.');

    var code = req.query['code'] as String;
    var client = new http.Client();
    var instagram = await instagramAuth.handleAuthorizationCode(code, client);
    var result = await verifier(instagram);
    client.close();
    return result;
  }
}
