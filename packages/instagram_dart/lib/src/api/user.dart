import 'dart:async';
import '../models/models.dart';

/// An abstraction to extract user information from Instagram.
abstract class InstagramUsersApi {
  /// Get information about the owner of the access token.
  InstagramUsersApiSelf get self;

  /// Get information about a user.
  Future<User> getById(String userId);

  /// Get the most recent media published by a user.
  ///
  /// The public_content scope is required if the user is not the owner of the access token.
  Future<List<Media>> getRecentMedia(String userId,
      {String maxId, String minId, int count});

  /// Get a list of users matching the query.
  Future<List<User>> search(String query, {int count});
}

/// An abstraction to extract information about the owner of the access token.
abstract class InstagramUsersApiSelf {
  /// Get information about the owner of the access token.
  Future<User> get();

  /// Get the most recent media published by the owner of the access token.
  Future<List<Media>> getRecentMedia({String maxId, String minId, int count});

  /// Get the list of recent media liked by the owner of the access token.
  Future<List<Media>> getLikedMedia({String maxLikeId, int count});
}
