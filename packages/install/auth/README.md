# auth
This add-on generates a simple boilerplate for using `package:galileo_auth` to perform
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
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';

Future configureServer(Galileo app) async {
  var auth = new GalileoAuth<User>(
    jwtKey: app.configuration['jwt_secret'],
    allowCookie: false,
  );
  auth.serializer = (User user) => user.id;
  auth.deserializer = (String id) => app.service('api/users').read(id).then(User.parse);
  app.use(auth.decodeJwt);
}
```
