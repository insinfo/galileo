/// Represents an Instagram API scope.
class InstagramApiScope {
  /// The desired access scope.
  final String scope;

  /// A scope allowing an application to read a user’s profile info and media.
  static const InstagramApiScope basic = const InstagramApiScope('basic');

  /// A scope allowing an application to read any public profile info and media on a user’s behalf.
  static const InstagramApiScope publicContent =
      const InstagramApiScope('public_content');

  /// A scope allowing an application to read the list of followers and followed-by users.
  static const InstagramApiScope followerList =
      const InstagramApiScope('follower_list');

  /// A scope allowing an application to post and delete comments on a user’s behalf.
  static const InstagramApiScope comments = const InstagramApiScope('comments');

  /// A scope allowing an application to follow and unfollow accounts on a user’s behalf.
  static const InstagramApiScope relationships =
      const InstagramApiScope('relationships');

  /// A scope allowing an application tto like and unlike media on a user’s behalf.
  static const InstagramApiScope likes = const InstagramApiScope('likes');

  /// A union of all scopes; use this for a client that needs full access to an account.
  static const List<InstagramApiScope> all = const [
    basic,
    publicContent,
    followerList,
    comments,
    relationships,
    likes
  ];

  const InstagramApiScope(this.scope);
}
