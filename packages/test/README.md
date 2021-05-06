# galileo_test
[![Pub](https://img.shields.io/pub/v/galileo_test.svg)](https://pub.dartlang.org/packages/galileo_test)
[![build status](https://travis-ci.org/galileo-dart/test.svg)](https://travis-ci.org/galileo-dart/test)

Testing utility library for the galileo framework.

# TestClient
The `TestClient` class is a custom `galileo_client` that sends mock requests to your server.
This means that you will not have to bind your server to HTTP to run.
Plus, it is an `galileo_client`, and thus supports services and other goodies.

The `TestClient` also supports WebSockets. WebSockets cannot be mocked (yet!) within this library,
so calling the `websocket()` function will also bind your server to HTTP, if it is not already listening.

The return value is a `WebSockets` client instance
(from [`package:galileo_websocket`](https://github.com/galileo-dart/websocket));

```dart
var ws = await client.websocket('/ws');
ws.service('api/users').onCreated.listen(...);

// To receive all blobs of data sent on the WebSocket:
ws.onData.listen(...);
```

# Matchers
Several `Matcher`s are bundled with this package, and run on any `package:http` `Response`,
not just those returned by galileo.

```dart
test('foo', () async {
    var res = await client.get('/foo');
    expect(res, allOf([
        isJson({'foo': 'bar'}),
        hasStatus(200),
        hasContentType(ContentType.JSON),
        hasContentType('application/json'),
        hasHeader('server'), // Assert header present
        hasHeader('server', 'galileo'), // Assert header present with value
        hasHeader('foo', ['bar', 'baz']), // ... Or multiple values
        hasBody(), // Assert non-empty body
        hasBody('{"foo":"bar"}') // Assert specific body
    ]));
});

test('error', () async {
    var res = await client.get('/error');
    expect(res, isgalileoHttpException());
    expect(res, isgalileoHttpException(statusCode: 404, message: ..., errors: [...])) // Optional
});
```

`hasValidBody` is one of the most powerful `Matcher`s in this library,
because it allows you to validate a JSON body against a
[validation schema](https://github.com/galileo-dart/validate).

galileo provides a comprehensive validation library that integrates tightly
with the very `matcher` package that you already use for testing. :)

[https://github.com/galileo-dart/validate](https://github.com/galileo-dart/validate)

```dart
test('validate response', () async {
    var res = await client.get('/bar');
    expect(res, hasValidBody(new Validator({
        'foo': isBoolean,
        'bar': [isString, equals('baz')],
        'age*': [],
        'nested': someNestedValidator
    })));
});
```
