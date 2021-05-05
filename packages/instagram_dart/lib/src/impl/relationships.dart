import 'dart:async';
import '../api/relationships.dart';
import '../models/models.dart';
import '../requestor.dart';

class InstagramRelationshipsApiImpl implements InstagramRelationshipsApi {
  static const String _root = '/v1/users/self';

  final Map<String, InstagramRelationshipsApiUser> _users = {};
  final Requestor requestor;

  InstagramRelationshipsApiImpl(this.requestor);

  @override
  InstagramRelationshipsApiUser toUser(String userId) {
    return _users.putIfAbsent(userId,
        () => new _InstagramRelationshipsApiUserImpl(requestor, userId));
  }

  @override
  Future<List<User>> getRequestedBy() {
    return requestor.request('$_root/requested-by').then((r) {
      return r.data.map((m) => new User.fromJson(m)).toList();
    });
  }

  @override
  Future<List<User>> getFollowers() {
    return requestor.request('$_root/followed-by').then((r) {
      return r.data.map((m) => new User.fromJson(m)).toList();
    });
  }

  @override
  Future<List<User>> getFollowing() {
    return requestor.request('$_root/follows').then((r) {
      return r.data.map((m) => new User.fromJson(m)).toList();
    });
  }
}

class _InstagramRelationshipsApiUserImpl
    implements InstagramRelationshipsApiUser {
  String _root;
  final Requestor requestor;

  _InstagramRelationshipsApiUserImpl(this.requestor, String userId) {
    _root = '/v1/users/$userId/relationship';
  }

  @override
  Future<Relationship> modify(String action) {
    return requestor
        .request(_root, method: 'POST', body: {'action': action}).then((r) {
      return new Relationship.fromJson(r.data);
    });
  }

  @override
  Future<Relationship> get() {
    return requestor.request(_root).then((r) {
      return new Relationship.fromJson(r.data);
    });
  }
}
