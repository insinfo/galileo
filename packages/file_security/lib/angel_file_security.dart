import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:path/path.dart' as p;
export 'src/virus_total.dart';

/// Applies restrictions to file uploads to protect your server from common exploits.
///
/// [maxFileSize] should be a size in bytes.
/// [allowedExtensions] should start with a leading `'.'`.
/// [allowedContentTypes] can contain either Strings or ContentTypes.
RequestMiddleware restrictFileUploads(
    {int maxFiles,
    int maxFileSize,
    Iterable<String> allowedExtensions,
    Iterable allowedContentTypes}) {
  if (maxFiles != null && maxFiles < 1)
    throw new ArgumentError('maxFiles must be a positive integer.');

  if (maxFileSize != null && maxFileSize < 1)
    throw new ArgumentError('maxFileSize must be a positive integer.');

  if (allowedExtensions?.isEmpty == true)
    print(
        'WARNING: You passed an empty Iterable for allowedExtensions, which is redundant. You may as well just remove the argument.');

  if (allowedContentTypes?.isEmpty == true)
    print(
        'WARNING: You passed an empty Iterable for allowedContentTypes, which is redundant. You may as well just remove the argument.');

  if (allowedContentTypes != null &&
      allowedContentTypes.any((t) => t is! String && t is! ContentType))
    throw new ArgumentError(
        'allowedContentTypes can only contain Strings and ContentTypes.');

  List<String> _allowedContentTypes = allowedContentTypes != null
      ? allowedContentTypes.map((type) {
          if (type is ContentType)
            return type.mimeType;
          else
            return type;
        }).toList()
      : null;

  return (RequestContext req, ResponseContext res) async {
    await req.parse();
    // Max files
    if (maxFiles != null && req.files.length > maxFiles)
      throw new AngelHttpException(null,
          statusCode: 413,
          message: 'Max upload amount of $maxFiles file(s) was exceeded.');

    // Max file size
    if (maxFileSize != null &&
        req.files.any((file) => file.data.length > maxFileSize))
      throw new AngelHttpException(null,
          statusCode: 413,
          message: 'Uploaded file exceeded max size of $maxFileSize byte(s).');

    if (allowedExtensions?.isNotEmpty == true) {
      if (req.files.any(
          (file) => !allowedExtensions.contains(p.extension(file.filename))))
        throw new AngelHttpException.badRequest(
            message:
                'Files must have one of the following extensions: ${allowedExtensions.join(",")}');
    }

    if (_allowedContentTypes?.isNotEmpty == true) {
      if (req.files
          .any((file) => !_allowedContentTypes.contains(file.mimeType)))
        throw new AngelHttpException.badRequest(
            message:
                'Files must have one of the following MIME types: ${_allowedContentTypes.join(",")}');
    }

    return true;
  };
}
