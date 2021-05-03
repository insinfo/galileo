# Testing

* [Testing](testing.md#testing)
  * [`connectTo(...)`](testing.md#connectto)
  * [`isJson(..)`](testing.md#isjson)
  * [`hasStatus(...)`](testing.md#hasstatus)
  * [More Matchers...](testing.md#more-matchers)
* [Next Up...](testing.md#next-up)

## Testing

Dart already has fantastic testing support, through a library of [testing helpers](https://github.com/angel-dart/test) that will make test writing faster. The following functions are exported by [`package:angel_test`](https://github.com/angel-dart/test), and will make your testing much easier.

### connectTo

[Full definition](https://www.dartdocs.org/documentation/angel_test/latest/angel_test/connectTo.html)

This function will start `app` on an available port, and return a `TestClient` instance \(based on [`package:angel_client`](https://github.com/angel-dart/client)\) configured to send requests to the server. The client also supports session manipulation.

```dart
main() {
  TestClient client;

  setUp(() async {
    client = await connectTo(myApp);
  });

  // Shut down server, and cancel pending requests
  tearDown(() => client.close());

  test('hello', () async {
    // The server URL is automatically prepended to paths.
    // This returns an http.Response. :)
    var response = await client.get('/hello');
  });
}
```

### isJson

A `Matcher` that asserts that the given `http.Response` equals `value` when decoded as JSON. This uses `test.equals` internally, so anything that would pass that matcher passes this one.

### hasStatus

A `Matcher` that asserts the given `http.Response` has the given `status` code.

### More Matchers

The complete set of `angel_test` Matchers can be found [here](https://www.dartdocs.org/documentation/angel_test/latest/angel_test/angel_test-library.html).

## Next Up...

1. Find out how to [handle errors](error-handling.md) in an Angel application.
2. Learn how to use the handy [Angel CLI](https://github.com/angel-dart/cli).

