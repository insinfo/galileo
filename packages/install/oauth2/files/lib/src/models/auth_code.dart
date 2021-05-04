library {{ project_name }}.src.models.auth_code;

import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';
part 'auth_code.g.dart';

@serializable
class _AuthCode extends Model {
  String userId, applicationId, state, redirectUri;
  List<String> scopes;
}
