// GENERATED CODE - DO NOT MODIFY BY HAND

part of {{ project_name }}.src.models.auth_code;

// **************************************************************************
// Generator: JsonModelGenerator
// **************************************************************************

class AuthCode extends _AuthCode {
  @override
  String id;

  @override
  String userId;

  @override
  String applicationId;

  @override
  String state;

  @override
  String redirectUri;

  @override
  List<String> scopes;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  AuthCode(
      {this.id,
      this.userId,
      this.applicationId,
      this.state,
      this.redirectUri,
      this.scopes,
      this.createdAt,
      this.updatedAt});

  factory AuthCode.fromJson(Map data) {
    return new AuthCode(
        id: data['id'],
        userId: data['user_id'],
        applicationId: data['application_id'],
        state: data['state'],
        redirectUri: data['redirect_uri'],
        scopes: data['scopes'],
        createdAt: data['created_at'] is DateTime
            ? data['created_at']
            : (data['created_at'] is String
                ? DateTime.parse(data['created_at'])
                : null),
        updatedAt: data['updated_at'] is DateTime
            ? data['updated_at']
            : (data['updated_at'] is String
                ? DateTime.parse(data['updated_at'])
                : null));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'application_id': applicationId,
        'state': state,
        'redirect_uri': redirectUri,
        'scopes': scopes,
        'created_at': createdAt == null ? null : createdAt.toIso8601String(),
        'updated_at': updatedAt == null ? null : updatedAt.toIso8601String()
      };

  static AuthCode parse(Map map) => new AuthCode.fromJson(map);

  AuthCode clone() {
    return new AuthCode.fromJson(toJson());
  }
}
