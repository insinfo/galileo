// GENERATED CODE - DO NOT MODIFY BY HAND

part of {{ project_name }}.src.models.auth_token;

// **************************************************************************
// Generator: JsonModelGenerator
// **************************************************************************

class AuthToken extends _AuthToken {
  @override
  String id;

  @override
  String userId;

  @override
  String applicationId;

  @override
  String state;

  @override
  String refreshToken;

  @override
  List<String> scopes;

  @override
  int lifeSpan;

  @override
  DateTime createdAt;

  @override
  DateTime updatedAt;

  AuthToken(
      {this.id,
      this.userId,
      this.applicationId,
      this.state,
      this.refreshToken,
      this.scopes,
      this.lifeSpan,
      this.createdAt,
      this.updatedAt});

  factory AuthToken.fromJson(Map data) {
    return new AuthToken(
        id: data['id'],
        userId: data['user_id'],
        applicationId: data['application_id'],
        state: data['state'],
        refreshToken: data['refresh_token'],
        scopes: data['scopes'],
        lifeSpan: data['life_span'],
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
        'refresh_token': refreshToken,
        'scopes': scopes,
        'life_span': lifeSpan,
        'created_at': createdAt == null ? null : createdAt.toIso8601String(),
        'updated_at': updatedAt == null ? null : updatedAt.toIso8601String()
      };

  static AuthToken parse(Map map) => new AuthToken.fromJson(map);

  AuthToken clone() {
    return new AuthToken.fromJson(toJson());
  }
}
