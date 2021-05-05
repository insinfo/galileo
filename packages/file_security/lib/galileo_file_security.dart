import 'dart:async';
import 'dart:io';
import 'package:galileo_framework/Galileo_framework.dart';
import 'package:path/path.dart' as p;
//export 'virus_total.dart';

/// Applies restrictions to file uploads to protect your server from common exploits.
///
/// [maxFileSize] should be a size in bytes.
/// [allowedExtensions] should start with a leading `'.'`.
/// [allowedContentTypes] can contain either Strings or ContentTypes.
class FileSecurityMiddleware {
  FileSecurityMiddleware({
    this.maxFiles,
    this.maxFileSize,
    this.allowedExtensions,
    this.allowedContentTypes,
  });

  int maxFiles;
  int maxFileSize;
  Iterable<String> allowedExtensions;
  Iterable allowedContentTypes;

  Future<bool> handleRequest(RequestContext req, ResponseContext res) async {
    if (maxFiles != null && maxFiles < 1) {
      throw ArgumentError('maxFiles must be a positive integer.');
    }

    if (maxFileSize != null && maxFileSize < 1) {
      throw ArgumentError('maxFileSize must be a positive integer.');
    }

    if (allowedExtensions?.isEmpty == true) {
      print(
          'WARNING: You passed an empty Iterable for allowedExtensions, which is redundant. You may as well just remove the argument.');
    }

    if (allowedContentTypes?.isEmpty == true) {
      print(
          'WARNING: You passed an empty Iterable for allowedContentTypes, which is redundant. You may as well just remove the argument.');
    }

    if (allowedContentTypes != null && allowedContentTypes.any((t) => t is! String && t is! ContentType)) {
      throw ArgumentError('allowedContentTypes can only contain Strings and ContentTypes.');
    }

    final List<String> _allowedContentTypes = allowedContentTypes != null
        ? allowedContentTypes.map((type) {
            if (type is ContentType)
              return type.mimeType;
            else
              return type.toString();
          }).toList()
        : null;

    await req.parseBody();
    // Max files
    if (maxFiles != null && req.uploadedFiles.length > maxFiles)
      throw GalileoHttpException(null,
          statusCode: 413, message: 'Max upload amount of $maxFiles file(s) was exceeded.');
    //any((UploadedFile file) => > maxFileSize)
    // Max file size
    if (maxFileSize != null) {
      for (var file in req.uploadedFiles) {
        final fileLen = await file.data.length;
        if (fileLen > maxFileSize)
          throw GalileoHttpException(null,
              statusCode: 413, message: 'Uploaded file exceeded max size of $maxFileSize byte(s).');
      }
    }

    if (allowedExtensions?.isNotEmpty == true) {
      if (req.uploadedFiles.any((f) => !allowedExtensions.contains(p.extension(f.filename)))) {
        throw GalileoHttpException.badRequest(
            message: 'Files must have one of the following extensions: ${allowedExtensions.join(",")}');
      }
    }

    if (_allowedContentTypes?.isNotEmpty == true) {
      if (req.uploadedFiles.any((file) => !_allowedContentTypes.contains(file.contentType)))
        throw GalileoHttpException.badRequest(
            message: 'Files must have one of the following MIME types: ${_allowedContentTypes.join(",")}');
    }

    return true;
  }
}
