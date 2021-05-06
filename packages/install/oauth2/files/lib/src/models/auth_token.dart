library {{ project_name }}.src.models.auth_token;

import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'auth_token.g.dart';

@serializable
class _AuthToken extends Model {
  String userId, applicationId, state, refreshToken;
  List<String> scopes;
  int lifeSpan;

  bool get expired {
    var now = new DateTime.now().toUtc();
    var expiry = createdAt.add(new Duration(milliseconds: lifeSpan));
    return now.isAfter(expiry);
  }
}
