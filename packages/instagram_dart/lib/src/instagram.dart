import 'dart:async';
import 'dart:convert';
import 'package:http/src/base_client.dart' as http;
import 'package:http/src/request.dart' as http;
import 'package:http/src/response.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'api/api.dart';
import 'impl/instagram.dart';
import 'models/impl_models.dart';
import 'models/models.dart';
import 'endpoints.dart';
import 'requestor.dart';
import 'scopes.dart';

/// Manages authentication against the Instagram API.
class InstagramApiAuth {
  final String clientId, clientSecret;
  final Uri redirectUri;
  final List<InstagramApiScope> scopes = [];

  InstagramApiAuth(this.clientId, this.clientSecret,
      {this.redirectUri, Iterable<InstagramApiScope> scopes: const []}) {
    this.scopes.addAll(scopes ?? []);
  }

  /// Creates or returns an OAuth2 grant that will be used to authenticate against the API.
  oauth2.AuthorizationCodeGrant get grant => new oauth2.AuthorizationCodeGrant(
      clientId, authorizationEndpoint, tokenEndpoint,
      secret: clientSecret);

  /// Returns a redirect URI that users can use to authenticate with the current application.
  ///
  /// You may optionally pass a [state] that will be forwarded back to your server. Use this
  /// to mitigate CSRF issues.
  Uri getRedirectUri({String state}) {
    if (redirectUri == null)
      throw new StateError(
          'You have not provided a `redirectUri` to this InstagramApiAuth instance.');
    return grant.getAuthorizationUrl(redirectUri,
        scopes: scopes.map((s) => s.scope), state: state);
  }

  /// Returns a URI that users can be redirected to to authenticate via applications with no server-side component.
  Uri getImplicitRedirectUri() {
    if (redirectUri == null)
      throw new StateError(
          'You have not provided a `redirectUri` to this InstagramApiAuth instance.');
    return authorizationEndpoint.replace(queryParameters: {
      'client_id': clientId,
      'redirect_uri': redirectUri.toString(),
      'response_type': 'token',
      'scope': scopes.map((s) => s.scope).join(' '),//_delimiter shouls be from AuthorizationCodeGrant
    });
  }

  /// Parses an Instagram access token response.
  static AccessTokenResponse parseAccessTokenResponse(http.Response response) {
    if (response.headers['content-type']?.contains('application/json') != true)
      throw new FormatException('The response is not formatted as JSON.');
    var untyped = JSON.decode(response.body);

    if (untyped is! Map)
      throw new FormatException('Expected the response to be a JSON object.');

    if (!untyped.containsKey('access_token') || !untyped.containsKey('user')) {
      print('Hm: ${untyped}');
      throw new FormatException(
          'Expected both an "access_token" and a "user".');
    }

    return new AccessTokenResponse.fromJson(new Map.from(untyped));
  }

  /// Creates an API client from an access token.
  ///
  /// You can optionally pass a [User], if you already have a reference to one.
  static InstagramApi authorizeViaAccessToken(
      String accessToken, http.BaseClient httpClient,
      {User user}) {
    return new InstagramApiImpl(
        accessToken, user, new _RequestorImpl(accessToken, httpClient));
  }

  /// Creates an API from a parsed access token response.
  static InstagramApi authorize(
      AccessTokenResponse accessTokenResponse, http.BaseClient httpClient) {
    return authorizeViaAccessToken(accessTokenResponse.accessToken, httpClient,
        user: accessTokenResponse.user);
  }

  /// Handles an access token response, and returns an API client.
  static InstagramApi handleAccessTokenResponse(
      http.Response response, http.BaseClient httpClient) {
    return authorize(parseAccessTokenResponse(response), httpClient);
  }

  /// Upgrades an OAuth2 authorization code into an access token, and returns an API client.
  Future<InstagramApi> handleAuthorizationCode(
      String code, http.BaseClient httpClient) async {
    Map<String, String> data = {
      'client_id': clientId,
      'client_secret': clientSecret,
      'grant_type': 'authorization_code',
      'redirect_uri': redirectUri.toString(),
      'code': code
    };
    var response = await httpClient.post(tokenEndpoint,
        body: data, headers: {'accept': 'application/json'});
    return handleAccessTokenResponse(response, httpClient);
  }

  /// Creates a [SubscriptionManager] with your [clientId] and [clientSecret].
  SubscriptionManager createSubscriptionManager(http.BaseClient client) {
    return new _SubscriptionManagerImpl(clientId, clientSecret, client);
  }
}

class _SubscriptionManagerImpl implements SubscriptionManager {
  final String clientId, clientSecret;
  final http.BaseClient client;

  _SubscriptionManagerImpl(this.clientId, this.clientSecret, this.client);

  Future<InstagramResponse> send(String method,
      {Map<String, String> body, Map<String, String> queryParameters}) {
    var uri = _RequestorImpl._root.replace(path: '/v1/subscriptions');

    var q = {'client_id': clientId, 'client_secret': clientSecret}
      ..addAll(queryParameters ?? {});
    uri = uri.replace(queryParameters: q);

    var request = new http.Request(method, uri);
    request.headers['accept'] = 'application/json';

    if (body?.isNotEmpty == true) {
      request.bodyFields = {
        'client_id': clientId,
        'client_secret': clientSecret
      }..addAll(body);
    }

    return client
        .send(request)
        .then<http.Response>(http.Response.fromStream)
        .then((response) {
      if (response.headers['content-type']?.contains('application/json') !=
          true)
        throw new FormatException(
            'The response is not formatted as JSON: "${response.body}"');
      var untyped = JSON.decode(response.body);

      if (untyped is! Map)
        throw new FormatException('Expected the response to be a JSON object.');

      var r = new InstagramResponse.fromJson(untyped);

      if (r.meta.code != 200) throw r.meta;

      return r;
    });
  }

  @override
  Future<bool> deleteAll() => deleteByObject(SubscriptionObject.all);

  @override
  Future<bool> deleteByObject(String object) {
    return send('DELETE', queryParameters: {'object': object})
        .then<bool>((_) => true);
  }

  @override
  Future<bool> delete(String subscriptionId) {
    return send('DELETE', queryParameters: {'id': subscriptionId})
        .then<bool>((_) => true);
  }

  @override
  Future<Subscription> create(
      String object, String aspect, String verifyToken, String callbackUrl) {
    return send('POST', body: {
      'object': object,
      'aspect': aspect,
      'verify_token': verifyToken,
      'callback_url': callbackUrl
    }).then<Subscription>((r) => new Subscription.fromJson(r.data));
  }

  @override
  Future<List<Subscription>> fetchAll() {
    return send('GET').then<List<Subscription>>(
        (r) => r.data.map((m) => new Subscription.fromJson(m)).toList());
  }
}

class _RequestorImpl extends Requestor {
  static final Uri _root = Uri.parse('https://api.instagram.com/v1');
  final String accessToken;
  final http.BaseClient client;

  _RequestorImpl(this.accessToken, this.client);

  @override
  Future<InstagramResponse> send(http.Request request) {
    return client
        .send(request)
        .then<http.Response>(http.Response.fromStream)
        .then((response) {
      if (response.headers['content-type']?.contains('application/json') !=
          true)
        throw new FormatException(
            'The response is not formatted as JSON: "${response.body}"');
      var untyped = JSON.decode(response.body);

      if (untyped is! Map)
        throw new FormatException('Expected the response to be a JSON object.');

      var r = new InstagramResponse.fromJson(untyped);

      if (r.meta.code != 200) throw r.meta;

      return r;
    });
  }

  @override
  Uri buildUri(String path,
      {Map<String, String> queryParameters, String method}) {
    Map<String, String> q =
        method == 'POST' ? {} : {'access_token': accessToken}
          ..addAll(queryParameters ?? {});
    if (q.isEmpty) return _root.replace(path: path);
    return _root.replace(path: path, queryParameters: q);
  }

  @override
  Map<String, String> buildBody(Map<String, String> body) {
    return new Map<String, String>.from(body)..['access_token'] = accessToken;
  }
}
