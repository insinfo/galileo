# auth_local
This add-on generates a simple boilerplate for using `package:angel_auth` to perform
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

import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:collection/collection.dart';
import '../models/user.dart';

/// Configures the server to perform username+password authentication.
///
/// [computePassword] should be a function that generates a list of bytes, ex. a SHA256 hash.
AngelConfigurer configureServer(AngelAuth<User> auth, List<int> computePassword(String password, User user)) {
  return (Angel app) async {
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
