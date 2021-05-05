import 'package:owl/annotation/json.dart';
import 'impl_models.g.dart';

@JsonClass()
class InstagramResponse {
  InstagramException meta;
  InstagramResponsePagination pagination;

  @JsonField(native: true)
  dynamic data;

  InstagramResponse({this.meta, this.pagination, this.data: const {}});
  factory InstagramResponse.fromJson(Map map) =>
      InstagramResponseMapper.parse(map);
  Map<String, dynamic> toJson() => InstagramResponseMapper.map(this);
}

@JsonClass()
class InstagramException implements Exception {
  int code;

  @JsonField(key: 'error_type')
  String errorType;

  @JsonField(key: 'error_message')
  String errorMessage;

  InstagramException({this.code, this.errorType, this.errorMessage});
  factory InstagramException.fromJson(Map map) =>
      InstagramExceptionMapper.parse(map);
  Map<String, dynamic> toJson() => InstagramExceptionMapper.map(this);

  @override
  String toString() {
    return '$errorType ($code): $errorMessage';
  }
}

@JsonClass()
class InstagramResponsePagination {
  @JsonField(key: 'next_url')
  String nextUrl;

  @JsonField(key: 'next_max_id')
  String nextMaxId;

  InstagramResponsePagination({this.nextUrl, this.nextMaxId});
  factory InstagramResponsePagination.fromJson(Map map) =>
      InstagramResponsePaginationMapper.parse(map);
  Map<String, dynamic> toJson() => InstagramResponsePaginationMapper.map(this);
}

@JsonClass()
class InstagramAuthException implements Exception {
  String error;

  @JsonField(key: 'error_reason')
  String errorReason;

  @JsonField(key: 'error_description')
  String errorDescription;

  InstagramAuthException({this.error, this.errorReason, this.errorDescription});
  factory InstagramAuthException.fromJson(Map map) =>
      InstagramAuthExceptionMapper.parse(map);
  Map<String, dynamic> toJson() => InstagramAuthExceptionMapper.map(this);
}
