import '../api/tag.dart';
import '../requestor.dart';
import 'dart:async';
import 'package:instagram/src/models/models.dart';

class InstagramTagsApiImpl implements InstagramTagsApi {
  static const String _root = '/v1/tags';
  final Requestor requestor;

  InstagramTagsApiImpl(this.requestor);

  @override
  Future<List<Tag>> search(String query) {
    return requestor.request('$_root/search').then((r) {
      return r.data.map((m) => new Tag.fromJson(m)).toList();
    });
  }

  @override
  Future<List<Media>> getRecentMedia(String tagName,
      {String maxTagId, String minTagId, int count}) {
    Map<String, String> queryParameters = {};

    if (maxTagId != null) queryParameters['max_tag_id'] = maxTagId;
    if (minTagId != null) queryParameters['min_tag_id'] = minTagId;
    if (count != null) queryParameters['count'] = count.toString();

    return requestor
        .request('$_root/$tagName/media/recent',
            queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new Media.fromJson(m)).toList();
    });
  }

  @override
  Future<Tag> getByName(String tagName) {
    return requestor.request('$_root/$tagName').then((r) {
      return r.data.map((m) => new Tag.fromJson(m)).toList();
    });
  }
}
