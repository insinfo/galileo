import 'dart:async';
import '../models/models.dart';

/// An abstraction to extract media information from Instagram.
abstract class InstagramMediaApi {
  /// Get information about a media object.
  ///
  /// Use the type field to differentiate between image and video media in the response.
  ///
  /// You will also receive the user_has_liked field which tells you whether the owner of the access_token has liked this media.
  ///
  /// The public_content permission scope is required to get a media that does not belong to the owner of the access_token.
  Future<Media> getById(String mediaId);

  /// This endpoint returns the same response as GET /media/media-id.
  ///
  /// A media object's shortcode can be found in its shortlink URL.
  /// An example shortlink is http://instagram.com/p/tsxp1hhQTG/. Its corresponding shortcode is tsxp1hhQTG.
  Future<Media> getByShortcode(String shortcode);

  /// Search for recent media in a given area.
  Future<List<Media>> search({num lat, num lng, num distance});
}