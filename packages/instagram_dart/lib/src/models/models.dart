import 'package:owl/annotation/json.dart';
import 'models.g.dart';

@JsonClass()
class AccessTokenResponse {
  @JsonField(key: 'access_token')
  String accessToken;

  User user;

  AccessTokenResponse({this.accessToken, this.user});
  factory AccessTokenResponse.fromJson(Map map) =>
      AccessTokenResponseMapper.parse(map);
  Map<String, dynamic> toJson() => AccessTokenResponseMapper.map(this);
}

@JsonClass()
class User {
  String id, username, bio, website;
  UserCounts counts;

  @JsonField(key: 'full_name')
  String fullName;

  @JsonField(key: 'profile_picture')
  String profilePicture;

  User(
      {this.id,
      this.username,
      this.fullName,
      this.bio,
      this.website,
      this.counts});
  factory User.fromJson(Map map) => UserMapper.parse(map);
  Map<String, dynamic> toJson() => UserMapper.map(this);
}

@JsonClass()
class UserCounts {
  int media, follows;

  @JsonField(key: 'followed_by')
  int followedBy;

  UserCounts({this.media, this.follows, this.followedBy});
  factory UserCounts.fromJson(Map map) => UserCountsMapper.parse(map);
  Map<String, dynamic> toJson() => UserCountsMapper.map(this);
}

@JsonClass()
class Media {
  String id, type, filter, link;

  MediaCaption caption;

  @JsonField(key: 'users_in_photo')
  List<UserInPhoto> usersInPhoto;

  @JsonField(native: true)
  List<String> tags;

  CommentOrLikeCount comments, likes;

  User user;

  Location location;

  MediaImages images, videos;

  @JsonField(key: 'user_has_liked')
  bool userHasLiked;

  @JsonField(key: 'carousel_media')
  List<Media> carouselMedia;

  @Transient()
  DateTime createdTime;

  Media(
      {this.id,
      this.type,
      this.filter,
      this.link,
      this.caption,
      this.usersInPhoto: const [],
      this.tags: const [],
      this.comments,
      this.likes,
      this.user,
      this.location,
      this.images,
      this.videos,
      this.userHasLiked,
      this.carouselMedia,
      this.createdTime});
  factory Media.fromJson(Map map) {
    var m = MediaMapper.parse(map);
    if (map['created_time'] is String)
      m.createdTime = new DateTime.fromMillisecondsSinceEpoch(
          int.parse(map['created_time']) * 1000);
    return m;
  }

  Map<String, dynamic> toJson() {
    return MediaMapper.map(this)
      ..['created_time'] = createdTime == null
          ? null
          : (createdTime.millisecondsSinceEpoch / 1000).toString();
  }
}

/// The various types of media on Instagram.
abstract class MediaType {
  /// An image.
  static const String image = 'image';

  /// A video.
  static const String video = 'video';

  /// A carousel.
  static const String carousel = 'carousel';
}

@JsonClass()
class MediaCaption {
  String id, text;
  User from;

  @Transient()
  DateTime createdTime;

  MediaCaption({this.id, this.text, this.from});

  factory MediaCaption.fromJson(Map map) {
    var m = MediaCaptionMapper.parse(map);
    if (map['created_time'] is String)
      m.createdTime = new DateTime.fromMillisecondsSinceEpoch(
          int.parse(map['created_time']) * 1000);
    return m;
  }

  Map<String, dynamic> toJson() {
    return MediaCaptionMapper.map(this)
      ..['created_time'] = createdTime == null
          ? null
          : (createdTime.millisecondsSinceEpoch / 1000).toString();
  }
}

@JsonClass()
class Relationship {
  @JsonField(key: 'outgoing_status')
  String outgoingStatus;

  @JsonField(key: 'incoming_status')
  String incomingStatus;

  Relationship({this.incomingStatus, this.outgoingStatus});
  factory Relationship.fromJson(Map map) => RelationshipMapper.parse(map);
  Map<String, dynamic> toJson() => RelationshipMapper.map(this);
}

/// The various types of incoming relationship status on Instagram.
abstract class IncomingStatus {
  /// This user has no relationship to you.
  static const String none = 'none';

  /// This user follows you.
  static const String followedBy = 'followed_by';

  /// This user is requesting to follow you.
  static const String requestedBy = 'requested_by';

  /// You have blocked this user.
  static const String blockedByYou = 'blocked_by_you';
}

/// The various types of incoming relationship status on Instagram.
abstract class OutgoingStatus {
  /// You have no relationship to this user.
  static const String none = 'none';

  /// You follow this user.
  static const String follows = 'follows';

  /// You have requested to follow this user.
  static const String requested = 'requested';
}

/// The various actions that can be performed on a relationship on Instagram.
abstract class RelationshipAction {
  /// Follow a user.
  static const String follow = 'follow';

  /// Unfollow a user.
  static const String unfollow = 'unfollow';

  /// Approve a follow request.
  static const String approve = 'approve';

  /// Ignore a follow request.
  static const String ignore = 'ignore';
}

@JsonClass()
class MediaImages {
  @JsonField(key: 'low_resolution')
  MediaImage lowResolution;

  MediaImage thumbnail;

  @JsonField(key: 'standard_resolution')
  MediaImage standardResolution;

  MediaImages({this.lowResolution, this.thumbnail, this.standardResolution});
  factory MediaImages.fromJson(Map map) => MediaImagesMapper.parse(map);
  Map<String, dynamic> toJson() => MediaImagesMapper.map(this);
}

@JsonClass()
class MediaImage {
  String url;
  int width, height;

  MediaImage({this.url, this.width, this.height});
  factory MediaImage.fromJson(Map map) => MediaImageMapper.parse(map);
  Map<String, dynamic> toJson() => MediaImageMapper.map(this);
}

@JsonClass()
class CommentOrLikeCount {
  int count;
  CommentOrLikeCount({this.count});
  factory CommentOrLikeCount.fromJson(Map map) =>
      CommentOrLikeCountMapper.parse(map);
  Map<String, dynamic> toJson() => CommentOrLikeCountMapper.map(this);
}

@JsonClass()
class UserInPhoto {
  User user;
  UserInPhotoPosition position;
  UserInPhoto({this.user, this.position});
  factory UserInPhoto.fromJson(Map map) => UserInPhotoMapper.parse(map);
  Map<String, dynamic> toJson() => UserInPhotoMapper.map(this);
}

@JsonClass()
class UserInPhotoPosition {
  num x, y;
  UserInPhotoPosition({this.x, this.y});
  factory UserInPhotoPosition.fromJson(Map map) =>
      UserInPhotoPositionMapper.parse(map);
  Map<String, dynamic> toJson() => UserInPhotoPositionMapper.map(this);
}

@JsonClass()
class Comment {
  String id, text;
  User from;

  @Transient()
  DateTime createdTime;

  Comment({this.id, this.text, this.from, this.createdTime});

  factory Comment.fromJson(Map map) {
    var c = CommentMapper.parse(map);
    if (map['created_time'] is String)
      c.createdTime = new DateTime.fromMillisecondsSinceEpoch(
          int.parse(map['created_time']) * 1000);
    return c;
  }

  Map<String, dynamic> toJson() {
    return CommentMapper.map(this)
      ..['created_time'] = createdTime == null
          ? null
          : (createdTime.millisecondsSinceEpoch / 1000).toString();
  }
}

@JsonClass()
class Tag {
  String name;

  @JsonField(key: 'media_count')
  int mediaCount;

  Tag({this.name, this.mediaCount});
  factory Tag.fromJson(Map map) => TagMapper.parse(map);
  Map<String, dynamic> toJson() => TagMapper.map(this);
}

@JsonClass()
class Location {
  int id;
  String name;
  num latitude, longitude;

  Location({this.id, this.name, this.latitude, this.longitude});
  factory Location.fromJson(Map map) => LocationMapper.parse(map);
  Map<String, dynamic> toJson() => LocationMapper.map(this);
}

@JsonClass()
class Subscription {
  String id, type, aspect;

  @JsonField(key: 'callback_url')
  String callbackUrl;

  Subscription({this.id, this.type, this.aspect, this.callbackUrl});
  factory Subscription.fromJson(Map map) => SubscriptionMapper.parse(map);
  Map<String, dynamic> toJson() => SubscriptionMapper.map(this);
}

/// The various objects for Instagram subscriptions.
abstract class SubscriptionObject {
  static const String all = 'all';
  static const String user = 'user';
}

/// The various aspects for Instagram subscriptions.
abstract class SubscriptionAspect {
  static const String media = 'media';
}
