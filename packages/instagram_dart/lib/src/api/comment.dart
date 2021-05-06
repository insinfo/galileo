import 'dart:async';
import '../models/models.dart';

/// An abstraction to extract comment information from Instagram.
abstract class InstagramCommentsApi {
  /// An abstraction to extract comment information from a single Instagram post.
  InstagramCommentsApiMedia forMedia(String mediaId);
}

/// An abstraction to extract comment information from a single Instagram post.
abstract class InstagramCommentsApiMedia {
  /// Get a list of recent comments on a media object.
  ///
  /// The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<List<Comment>> getComments();

  /// Create a comment on a media object with the following rules:
  ///
  /// * The total length of the comment cannot exceed 300 characters.
  /// * The comment cannot contain more than 4 hashtags.
  /// * The comment cannot contain more than 1 URL.
  /// * The comment cannot consist of all capital letters.
  ///
  /// * The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<bool> createComment(String text);

  /// Remove a comment either on the authenticated user's media object or authored by the authenticated user.
  ///
  /// The public_content scope is required for media that does not belong to the owner of the access_token.
  Future<bool> deleteComment(String commentId);
}
