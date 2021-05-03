import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:galileo_validate/galileo_validate.dart';
import 'package:galileo_websocket/server.dart';
import 'package:test/test.dart';

main() {
  Galileo app;
  TestClient client;

  setUp(() async {
    app = new Galileo()
      ..get('/hello', (req, res) => 'Hello')
      ..get('/error',
          (req, res) => throw new GalileoHttpException.forbidden(message: 'Test')..errors.addAll(['foo', 'bar']))
      ..get('/body', (req, res) {
        res
          ..write('OK')
          ..close();
      })
      ..get(
          '/valid',
          (req, res) => {
                'michael': 'jackson',
                'billie': {'jean': 'hee-hee', 'is_my_lover': false}
              })
      ..post('/hello', (req, res) async {
        var body = await req.parseBody().then((_) => req.bodyAsMap);
        return {'bar': body['foo']};
      })
      ..get('/gzip', (req, res) async {
        res
          ..headers['content-encoding'] = 'gzip'
          ..add(gzip.encode('Poop'.codeUnits))
          ..close();
      })
      ..use(
          '/foo',
          new AnonymousService(
              index: ([params]) async => [
                    {'michael': 'jackson'}
                  ],
              create: (data, [params]) async => {'foo': 'bar'}));

    var ws = new GalileoWebSocket(app);
    await app.configure(ws.configureServer);
    app.all('/ws', ws.handleRequest);

    app.errorHandler = (e, req, res) => e.toJson();

    client = await connectTo(app);
  });

  tearDown(() async {
    await client.close();
    app = null;
  });

  group('matchers', () {
    group('isJson+hasStatus', () {
      test('get', () async {
        final response = await client.get(Uri.parse('/hello'));
        expect(response, isJson('Hello'));
      });

      test('post', () async {
        final response = await client.post(Uri.parse('/hello'), body: {'foo': 'baz'});
        expect(response, allOf(hasStatus(200), isJson({'bar': 'baz'})));
      });
    });

    test('isGalileoHttpException', () async {
      var res = await client.get(Uri.parse('/error'));
      print(res.body);
      expect(res, isGalileoHttpException());
      expect(res, isGalileoHttpException(statusCode: 403, message: 'Test', errors: ['foo', 'bar']));
    });

    test('hasBody', () async {
      var res = await client.get(Uri.parse('/body'));
      expect(res, hasBody());
      expect(res, hasBody('OK'));
    });

    test('hasHeader', () async {
      var res = await client.get(Uri.parse('/hello'));
      expect(res, hasHeader('server'));
      expect(res, hasHeader('server', 'galileo'));
      expect(res, hasHeader('server', ['galileo']));
    });

    test('hasValidBody+hasContentType', () async {
      var res = await client.get(Uri.parse('/valid'));
      expect(res, hasContentType('application/json'));
      expect(
          res,
          hasValidBody(new Validator({
            'michael*': [isString, isNotEmpty, equals('jackson')],
            'billie': new Validator({
              'jean': [isString, isNotEmpty],
              'is_my_lover': [isBool, isFalse]
            })
          })));
    });

    test('gzip decode', () async {
      var res = await client.get(Uri.parse('/gzip'));
      expect(res, hasHeader('content-encoding', 'gzip'));
      expect(res, hasBody('Poop'));
    });

    group('service', () {
      test('index', () async {
        var foo = client.service('foo');
        var result = await foo.index();
        expect(result, [
          {'michael': 'jackson'}
        ]);
      });

      test('index', () async {
        var foo = client.service('foo');
        var result = await foo.create({});
        expect(result, {'foo': 'bar'});
      });
    });

    test('websocket', () async {
      var ws = await client.websocket();
      var foo = ws.service('foo');
      foo.create({});
      var result = await foo.onCreated.first;
      expect(result.data, equals({'foo': 'bar'}));
    });
  });
}
