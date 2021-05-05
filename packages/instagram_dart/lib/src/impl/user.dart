import '../api/user.dart';
import '../models/models.dart';
import '../requestor.dart';
import 'dart:async';

const String _root = '/v1/users';

class InstagramUsersApiImpl implements InstagramUsersApi {
  _InstagramUsersApiSelfImpl _self;
  final Requestor requestor;

  InstagramUsersApiImpl(this.requestor);

  @override
  InstagramUsersApiSelf get self =>
      _self ??= new _InstagramUsersApiSelfImpl(this, requestor);

  @override
  Future<User> getById(String userId) {
    return requestor
        .request('$_root/$userId')
        .then((r) => new User.fromJson(r.data));
  }

  @override
  Future<List<Media>> getRecentMedia(String userId,
      {String maxId, String minId, int count}) {
    Map<String, String> queryParameters = {};

    if (maxId != null) queryParameters['max_id'] = maxId;
    if (minId != null) queryParameters['min_id'] = minId;
    if (count != null) queryParameters['count'] = count.toString();

    return requestor
        .request('$_root/$userId/media/recent',
            queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new Media.fromJson(m)).toList();
    });
  }

  @override
  Future<List<User>> search(String query, {int count}) {
    Map<String, String> queryParameters = {'q': query};

    if (count != null) queryParameters['count'] = count.toString();

    return requestor
        .request('$_root/search', queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new User.fromJson(m)).toList();
    });
  }
}

class _InstagramUsersApiSelfImpl implements InstagramUsersApiSelf {
  final InstagramUsersApiImpl parent;
  final Requestor requestor;

  _InstagramUsersApiSelfImpl(this.parent, this.requestor);

  @override
  Future<User> get() => parent.getById('self');

  @override
  Future<List<Media>> getLikedMedia({String maxLikeId, int count}) {
    Map<String, String> queryParameters = {};

    if (maxLikeId != null) queryParameters['max_like_id'] = maxLikeId;
    if (count != null) queryParameters['count'] = count.toString();

    return requestor
        .request('$_root/self/media/liked', queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new Media.fromJson(m)).toList();
    });
  }

  @override
  Future<List<Media>> getRecentMedia({String maxId, String minId, int count}) =>
      parent.getRecentMedia('self', maxId: maxId, minId: minId, count: count);
}
