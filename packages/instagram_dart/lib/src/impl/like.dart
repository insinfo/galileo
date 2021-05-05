import '../api/like.dart';
import '../models/models.dart';
import '../requestor.dart';
import 'dart:async';

class InstagramLikesApiImpl implements InstagramLikesApi {
  final Map<String, InstagramLikesApiMedia> _media = {};
  final Requestor requestor;

  InstagramLikesApiImpl(this.requestor);

  @override
  InstagramLikesApiMedia forMedia(String mediaId) {
    return _media.putIfAbsent(
        mediaId, () => new _InstagramLikesApiMediaImpl(mediaId, requestor));
  }
}

class _InstagramLikesApiMediaImpl implements InstagramLikesApiMedia {
  final String mediaId;
  final Requestor requestor;
  String _root;

  _InstagramLikesApiMediaImpl(this.mediaId, this.requestor) {
    _root = '/v1/media/$mediaId/likes';
  }

  @override
  Future<List<User>> getUsersWhoHaveLiked() {
    return requestor.request(_root).then((r) {
      return r.data.map((m) => new User.fromJson(m)).toList();
    });
  }

  @override
  Future<bool> like() {
    return requestor.request(_root, method: 'POST').then((r) {
      return true;
    });
  }

  @override
  Future<bool> unlike() {
    return requestor.request(_root, method: 'DELETE').then((r) {
      return true;
    });
  }
}
