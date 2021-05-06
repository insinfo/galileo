library {{ project_name }}.src.auth;

import 'dart:async';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_framework/galileo_framework.dart';
import '{{ model_path }}';

/// Configures the server to issue and verify JWT's.
Future configureServer(Galileo app) async {
  var auth = new GalileoAuth<{{ model }}>(
    jwtKey: app.configuration['jwt_secret'],
    allowCookie: false,
  );
  
  auth.serializer = ({{ model }} user) => user.id;
  auth.deserializer = (String id) => app.service('{{ service }}').read(id).then({{ model }}.parse);
  
  app.use(auth.decodeJwt);
}
