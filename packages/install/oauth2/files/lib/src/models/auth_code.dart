library {{ project_name }}.src.models.auth_code;

import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'auth_code.g.dart';

@serializable
class _AuthCode extends Model {
  String userId, applicationId, state, redirectUri;
  List<String> scopes;
}
