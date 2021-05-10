# galileo_client

[![Pub](https://img.shields.io/pub/v/galileo_client.svg)](https://pub.dartlang.org/packages/galileo_client)
[![build status](https://travis-ci.org/galileo-dart/client.svg)](https://travis-ci.org/galileo/galileo_client)

Client library for the galileo framework.
This library provides virtually the same API as an galileo server.
The client can run in the browser, in Flutter, or on the command-line.
In addition, the client supports `galileo_auth` authentication.

# Usage

```dart
// Choose one or the other, depending on platform
import 'package:galileo_client/io.dart';
import 'package:galileo_client/browser.dart';
import 'package:galileo_client/flutter.dart';

main() async {
  galileo app = new Rest("http://localhost:3000");
}
```

You can call `service` to receive an instance of `Service`, which acts as a client to a
service on the server at the given path (say that five times fast!).

```dart
foo() async {
  Service Todos = app.service("todos");
  List<Map> todos = await Todos.index();

  print(todos.length);
}
```

The CLI client also supports reflection via `json_god`. There is no need to work with Maps;
you can use the same class on the client and the server.

```dart
class Todo extends Model {
  String text;

  Todo({String this.text});
}

bar() async {
  // By the next release, this will just be:
  // app.service<Todo>("todos")
  Service Todos = app.service("todos", type: Todo);
  List<Todo> todos = await Todos.index();

  print(todos.length);
}
```

Just like on the server, services support `index`, `read`, `create`, `modify`, `update` and
`remove`.

## Authentication
Local auth:
```dart
var auth = await app.authenticate(type: 'local', credentials: {username: ..., password: ...});
print(auth.token);
print(auth.data); // User object
```

Revive an existing jwt:
```dart
Future<galileoAuthResult> reviveJwt(String jwt) {
  return app.authenticate(credentials: {'token': jwt});
}
```

Via Popup:
```dart
app.authenticateViaPopup('/auth/google').listen((jwt) {
  // Do something with the JWT
});
```

Resume a session from localStorage (browser only):
```dart
// Automatically checks for JSON-encoded 'token' in localStorage,
// and tries to revive it
await app.authenticate();
```

Logout:
```dart
await app.logout();
```

# Live Updates
Oftentimes, you will want to update a collection based on updates from a service.
Use `ServiceList` for this case:

```dart
build(BuildContext context) async {
  var list = new ServiceList(app.service('api/todos'));
  
  return new StreamBuilder(
    stream: list.onChange,
    builder: _yourBuildFunction,
  );
}
```
