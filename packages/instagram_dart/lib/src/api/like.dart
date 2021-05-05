import 'dart:async';
import '../models/models.dart';

/// An abstraction to extract like information from Instagram.
abstract class InstagramLikesApi {
  /// An abstraction to extract like information from a single Instagram post.
  InstagramLikesApiMedia forMedia(String mediaId);
}

/// An abstraction to extract like information from a single Instagram post.
abstract class InstagramLikesApiMedia {
  /// Get a list of users who have liked this media.
  ///
  /// The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<List<User>> getUsersWhoHaveLiked();

  /// Set a like on this media by the currently authenticated user.
  ///
  /// * The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<bool> like();

  /// Remove a like on this media by the currently authenticated user.
  ///
  /// The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<bool> unlike();
}

