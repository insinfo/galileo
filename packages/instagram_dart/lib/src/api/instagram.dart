import '../models/models.dart';
import 'comment.dart';
import 'like.dart';
import 'location.dart';
import 'media.dart';
import 'relationships.dart';
import 'tag.dart';
import 'user.dart';

/// An abstraction to extract information from Instagram.
abstract class InstagramApi {
  /// This client's access token.
  String get accessToken;

  /// The user who is logged-in for this session.
  User get user;

  /// An abstraction to extract comment information from Instagram.
  InstagramCommentsApi get comments;

  /// An abstraction to extract location information from Instagram.
  InstagramLocationsApi get locations;

  /// An abstraction to extract likes information from Instagram.
  InstagramLikesApi get likes;

  /// An abstraction to extract media information from Instagram.
  InstagramMediaApi get media;

  /// An abstraction to extract relationship information from Instagram.
  InstagramRelationshipsApi get relationships;

  /// An abstraction to extract tag information from Instagram.
  InstagramTagsApi get tags;

  /// An abstraction to extract user information from Instagram.
  InstagramUsersApi get users;
}