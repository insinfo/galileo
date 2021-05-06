import 'dart:async';
import '../models/models.dart';

/// An abstraction to extract relationship information from Instagram.
abstract class InstagramRelationshipsApi {
  /// Get the list of users this user follows.
  Future<List<User>> getFollowing();

  /// Get the list of users this user is followed by.
  Future<List<User>> getFollowers();

  /// List the users who have requested this user's permission to follow.
  Future<List<User>> getRequestedBy();

  /// An abstraction to extract information about the current user's relationship to another Instagram user.
  InstagramRelationshipsApiUser toUser(String userId);
}

/// An abstraction to extract information about the current user's relationship to another Instagram user.
abstract class InstagramRelationshipsApiUser {
  /// Get information about a relationship to another user.
  ///
  /// Relationships are expressed using the following terms in the response:
  ///  * `outgoing_status`: Your relationship to the user. Can be 'follows', 'requested', 'none'.
  ///  * `incoming_status`: A user's relationship to you. Can be 'followed_by', 'requested_by', 'blocked_by_you', 'none'.
  ///
  /// For constants, see [IncomingStatus] and [OutgoingStatus].
  Future<Relationship> get();

  /// Modify the relationship between the current user and the target user.
  ///
  /// You need to include an [action] parameter to specify the relationship action you want to perform.
  /// Valid actions are: 'follow', 'unfollow' 'approve' or 'ignore' See ([RelationshipAction] for constants).
  /// Relationships are expressed using the following terms in the response:
  Future<Relationship> modify(String action);
}
