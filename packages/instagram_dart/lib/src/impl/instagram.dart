import '../requestor.dart';
import '../api/api.dart';
import '../models/models.dart';
import 'comment.dart';
import 'like.dart';
import 'location.dart';
import 'media.dart';
import 'relationships.dart';
import 'tag.dart';
import 'user.dart';

class InstagramApiImpl implements InstagramApi {
  InstagramCommentsApi _comments;
  InstagramLikesApi _likes;
  InstagramLocationsApi _locations;
  InstagramMediaApi _media;
  InstagramRelationshipsApi _relationships;
  InstagramTagsApi _tags;
  InstagramUsersApi _users;

  @override
  final String accessToken;

  @override
  final User user;

  final Requestor requestor;

  InstagramApiImpl(this.accessToken, this.user, this.requestor);

  @override
  InstagramCommentsApi get comments =>
      _comments ??= new InstagramCommentsApiImpl(requestor);

  @override
  InstagramLikesApi get likes =>
      _likes ??= new InstagramLikesApiImpl(requestor);

  @override
  InstagramLocationsApi get locations =>
      _locations ??= new InstagramLocationsApiImpl(requestor);

  @override
  InstagramMediaApi get media =>
      _media ??= new InstagramMediaApiImpl(requestor);

  @override
  InstagramTagsApi get tags => _tags ??= new InstagramTagsApiImpl(requestor);

  @override
  InstagramRelationshipsApi get relationships =>
      _relationships ??= new InstagramRelationshipsApiImpl(requestor);

  @override
  InstagramUsersApi get users =>
      _users ??= new InstagramUsersApiImpl(requestor);
}
