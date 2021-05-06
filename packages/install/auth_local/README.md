# auth_local
This add-on generates a simple boilerplate for using `package:galileo_auth` to perform
username+password authentication.

## Parameters
* `model`: The name of the model class (default: `User`)
* `model_path`: The path to the model class, relative to `lib/src/auth` (default: `../models/user.dart`).
* `service`: The path of the users service (default: `api/users`).
* `password_field`: The name of the password field on the user model.
* `username_field`: The name of the username field on the user model.

## Generated Code
```dart
library <project-name>.src.auth.local;

import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:collection/collection.dart';
import '../models/user.dart';

/// Configures the server to perform username+password authentication.
///
/// [computePassword] should be a function that generates a list of bytes, ex. a SHA256 hash.
GalileoConfigurer configureServer(GalileoAuth<User> auth, List<int> computePassword(String password, User user)) {
  return (Galileo app) async {
    var strategy = new LocalAuthStrategy((username, password) async {
      var userService = app.service('api/users');
      Iterable<User> users = await userService.index({
        'query': {
          'username': username,
        },
      }).then((it) => it.map(User.parse));
      
      if (users.isEmpty)
        return null;
      var user = users.first;
      var hash = computePassword(password, user);
      if (!(const ListEquality().equals(hash, user.password)))
        return null;
      return user;
    });
    
    auth.strategies.add(strategy);
  };
}
```
