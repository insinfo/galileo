# auth
This add-on generates a simple boilerplate for using `package:angel_auth` to perform
JWT authentication.

Other `auth_*` addons can be plugged in here, simply by passing them the created `auth` object.

## Parameters
* `model`: The name of the model class (default: `User`)
* `model_path`: The path to the model class, relative to `lib/src` (default: `models/user.dart`).
* `service`: The path of the users service (default: `api/users`).

## Generated Code
```dart
library <project-name>.src.auth;

import 'dart:async';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';

Future configureServer(Angel app) async {
  var auth = new AngelAuth<User>(
    jwtKey: app.configuration['jwt_secret'],
    allowCookie: false,
  );
  auth.serializer = (User user) => user.id;
  auth.deserializer = (String id) => app.service('api/users').read(id).then(User.parse);
  app.use(auth.decodeJwt);
}
```
