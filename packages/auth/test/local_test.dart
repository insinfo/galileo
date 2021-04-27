import 'dart:async';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:test/test.dart';

final GalileoAuth<Map<String, String>> auth = GalileoAuth<Map<String, String>>();
var headers = <String, String>{'accept': 'application/json'};
var localOpts = GalileoAuthOptions<Map<String, String>>(failureRedirect: '/failure', successRedirect: '/success');
Map<String, String> sampleUser = {'hello': 'world'};

Future<Map<String, String>> verifier(String username, String password) async {
  if (username == 'username' && password == 'password') {
    return sampleUser;
  } else {
    return null;
  }
}

Future wireAuth(Galileo app) async {
  auth.serializer = (user) async => 1337;
  auth.deserializer = (id) async => sampleUser;

  auth.strategies['local'] = LocalAuthStrategy(verifier);
  await app.configure(auth.configureServer);
}

void main() async {
  Galileo app;
  GalileoHttp galileoHttp;
  http.Client client;
  String url;
  String basicAuthUrl;

  setUp(() async {
    client = http.Client();
    app = Galileo();
    galileoHttp = GalileoHttp(app, useZone: false);
    await app.configure(wireAuth);
    app.get('/hello', (req, res) => 'Woo auth', middleware: [auth.authenticate('local')]);
    app.post('/login', (req, res) => 'This should not be shown', middleware: [auth.authenticate('local', localOpts)]);
    app.get('/success', (req, res) => 'yep', middleware: [
      requireAuthentication<Map<String, String>>(),
    ]);
    app.get('/failure', (req, res) => 'nope');

    app.logger = Logger('galileo_auth')
      ..onRecord.listen((rec) {
        if (rec.error != null) {
          print(rec.error);
          print(rec.stackTrace);
        }
      });

    var server = await galileoHttp.startServer('127.0.0.1', 0);
    url = 'http://${server.address.host}:${server.port}';
    basicAuthUrl = 'http://username:password@${server.address.host}:${server.port}';
  });

  tearDown(() async {
    await galileoHttp.close();
    client = null;
    url = null;
    basicAuthUrl = null;
  });

  test('can use "auth" as middleware', () async {
    var response = await client.get(Uri.parse('$url/success'), headers: {'Accept': 'application/json'});
    print(response.body);
    expect(response.statusCode, equals(403));
  });

  test('successRedirect', () async {
    var postData = {'username': 'username', 'password': 'password'};
    var response = await client
        .post(Uri.parse('$url/login'), body: json.encode(postData), headers: {'content-type': 'application/json'});
    expect(response.statusCode, equals(302));
    expect(response.headers['location'], equals('/success'));
  });

  test('failureRedirect', () async {
    var postData = {'username': 'password', 'password': 'username'};
    var response = await client
        .post(Uri.parse('$url/login'), body: json.encode(postData), headers: {'content-type': 'application/json'});
    print('Login response: ${response.body}');
    expect(response.headers['location'], equals('/failure'));
    expect(response.statusCode, equals(401));
  });

  test('allow basic', () async {
    var authString = base64.encode('username:password'.runes.toList());
    var response = await client.get(Uri.parse('$url/hello'), headers: {'authorization': 'Basic $authString'});
    expect(response.body, equals('"Woo auth"'));
  });

  test('allow basic via URL encoding', () async {
    var response = await client.get(Uri.parse('$basicAuthUrl/hello'));
    expect(response.body, equals('"Woo auth"'));
  });

  test('force basic', () async {
    auth.strategies.clear();
    auth.strategies['local'] = LocalAuthStrategy(verifier, forceBasic: true, realm: 'test');
    var response = await client
        .get(Uri.parse('$url/hello'), headers: {'accept': 'application/json', 'content-type': 'application/json'});
    print(response.headers);
    print('Body <${response.body}>');
    expect(response.headers['www-authenticate'], equals('Basic realm="test"'));
  });
}
