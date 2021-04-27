import 'dart:async';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';

main() async {
  var app = Galileo();
  var auth = GalileoAuth<User>();

  auth.serializer = (user) => user.id;

  auth.deserializer = (id) => fetchAUserByIdSomehow(id);

  // Middleware to decode JWT's and inject a user object...
  await app.configure(auth.configureServer);

  auth.strategies['local'] = LocalAuthStrategy((username, password) {
    // Retrieve a user somehow...
    // If authentication succeeds, return a User object.
    //
    // Otherwise, return `null`.
  });

  app.post('/auth/local', auth.authenticate('local'));

  var http = GalileoHttp(app);
  await http.startServer('127.0.0.1', 3000);

  print('Listening at http://127.0.0.1:3000');
}

class User {
  String id, username, password;
}

Future<User> fetchAUserByIdSomehow(id) async {
  // Fetch a user somehow...
  throw UnimplementedError();
}
