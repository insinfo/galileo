library {{ project_name }}.src.auth;

import 'dart:async';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import '{{ model_path }}';

/// Configures the server to issue and verify JWT's.
Future configureServer(Angel app) async {
  var auth = new AngelAuth<{{ model }}>(
    jwtKey: app.configuration['jwt_secret'],
    allowCookie: false,
  );
  
  auth.serializer = ({{ model }} user) => user.id;
  auth.deserializer = (String id) => app.service('{{ service }}').read(id).then({{ model }}.parse);
  
  app.use(auth.decodeJwt);
}
