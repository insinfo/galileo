import '../api/location.dart';
import '../models/models.dart';
import '../requestor.dart';
import 'dart:async';

class InstagramLocationsApiImpl implements InstagramLocationsApi {
  static const String _root = '/v1/locations';
  final Requestor requestor;

  InstagramLocationsApiImpl(this.requestor);

  @override
  Future<List<Location>> search(
      {num lat, num lng, num distance, String facebookPlacesId}) {
    Map<String, String> queryParameters = {};

    if (lat != null) queryParameters['lat'] = lat.toString();
    if (lng != null) queryParameters['lng'] = lng.toString();
    if (distance != null) queryParameters['distance'] = distance.toString();
    if (facebookPlacesId != null)
      queryParameters['facebook_places_id'] = facebookPlacesId;

    return requestor
        .request('$_root/search', queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new Location.fromJson(m)).toList();
    });
  }

  @override
  Future<List<Media>> getRecentMedia(String locationId,
      {String maxId, String minId}) {
    Map<String, String> queryParameters = {};

    if (maxId != null) queryParameters['max_tag_id'] = maxId;
    if (minId != null) queryParameters['min_tag_id'] = minId;

    return requestor
        .request('$_root/$locationId/media/recent',
            queryParameters: queryParameters)
        .then((r) {
      return r.data.map((m) => new Location.fromJson(m)).toList();
    });
  }

  @override
  Future<Location> getById(String locationId) {
    return requestor.request('$_root/$locationId').then((r) {
      return r.data.map((m) => new Location.fromJson(m)).toList();
    });
  }
}
