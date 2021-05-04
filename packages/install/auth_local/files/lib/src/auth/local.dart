library {{ project_name }}.src.auth.local;

import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:collection/collection.dart';
import '{{ model_path }}';

/// Configures the server to perform {{ username_field }}+{{ password_field }} authentication.
///
/// [computePassword] should be a function that generates a list of bytes, ex. a SHA256 hash.
AngelConfigurer configureServer(AngelAuth<{{ model }}> auth, List<int> computePassword(String {{ password_field }}, {{ model }} user)) {
  return (Angel app) async {
    var strategy = new LocalAuthStrategy(({{ username_field }}, {{ password_field }}) async {
      var userService = app.service('{{ service }}');
      Iterable<{{ model }}> users = await userService.index({
        'query': {
          '{{ username_field }}': {{ username_field }},
        },
      }).then((it) => it.map({{ model }}.parse));
      
      if (users.isEmpty)
        return null;
        
      var user = users.first;
      var hash = computePassword({{ password_field }}, user);
      
      if (!(const ListEquality().equals(hash, user.{{ password_field }})))
        return null;
        
      return user;
    });
    
    auth.strategies.add(strategy);
  };
}
