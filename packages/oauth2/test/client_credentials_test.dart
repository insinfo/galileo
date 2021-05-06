import 'dart:async';
import 'dart:convert';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:galileo_oauth2/galileo_oauth2.dart';
import 'package:test/test.dart';
import 'common.dart';

void main() {
  TestClient client;

  setUp(() async {
    var app = Galileo();
    var oauth2 = _AuthorizationServer();

    app.group('/oauth2', (router) {
      router
        ..get('/authorize', oauth2.authorizationEndpoint)
        ..post('/token', oauth2.tokenEndpoint);
    });

    app.errorHandler = (e, req, res) async {
      res.json(e.toJson());
    };

    client = await connectTo(app);
  });

  tearDown(() => client.close());

  test('authenticate via client credentials', () async {
    var response = await client.post(
      '/oauth2/token',
      headers: {
        'Authorization': 'Basic ' + base64Url.encode('foo:bar'.codeUnits),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    print('Response: ${response.body}');

    // TODO: Incorrect Validators
    /*
    expect(
        response,
        allOf(
          hasStatus(200),
          hasContentType('application/json'),
          hasValidBody(Validator({
            'token_type': equals('bearer'),
            'access_token': equals('foo'),
          })),
        ));
        */
  });

  test('force correct id', () async {
    var response = await client.post(
      '/oauth2/token',
      headers: {
        'Authorization': 'Basic ' + base64Url.encode('fooa:bar'.codeUnits),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    print('Response: ${response.body}');
    expect(response, hasStatus(400));
  });

  test('force correct secret', () async {
    var response = await client.post(
      '/oauth2/token',
      headers: {
        'Authorization': 'Basic ' + base64Url.encode('foo:bara'.codeUnits),
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    print('Response: ${response.body}');
    expect(response, hasStatus(400));
  });
}

class _AuthorizationServer
    extends AuthorizationServer<PseudoApplication, PseudoUser> {
  @override
  PseudoApplication findClient(String clientId) {
    return clientId == pseudoApplication.id ? pseudoApplication : null;
  }

  @override
  Future<bool> verifyClient(
      PseudoApplication client, String clientSecret) async {
    return client.secret == clientSecret;
  }

  @override
  Future<AuthorizationTokenResponse> clientCredentialsGrant(
      PseudoApplication client, RequestContext req, ResponseContext res) async {
    return AuthorizationTokenResponse('foo');
  }
}
