`package:galileo_framework` has nice support for injecting values from HTTP headers, query string, and session/cookie values, as well as pattern-matching for request handlers. 

These act as a clean shorthand for commonly-used
functionality.

Here is a simple example of each of them in action:

```dart
app.get('/cookie', ioc((@CookieValue('token') String jwt) {
    return jwt;
}));

app.get('/header', ioc((@Header('x-foo') String header) {
    return header;
}));

app.get('/query', ioc((@Query('q') String query) {
    return query;
}));

app.get('/session', ioc((@Session('foo') String foo) {
    return foo;
}));

app.get('/match', ioc((@Query('mode', match: 'pos') String mode) {
    return 'YES $mode';
}));

app.get('/match', ioc((@Query('mode', match: 'neg') String mode) {
    return 'NO $mode';
}));

app.get('/match', ioc((@Query('mode') String mode) {
    return 'DEFAULT $mode';
}));
```

## `@Header()`
A simple parameter annotation to inject the value of a sent HTTP header. Throws a 400 if the header is absent.

## `@Query()`
Searches for the value of a query parameter.

## `@Session()`
Fetches a value from the session.

## `@CookieValue()`
Gets the value of a cookie.

## `@Parameter()`
The base class driving the above matchers.

Supports:
* `defaultValue`
* `required`
* custom `error` message

https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/Parameter-class.html
