# file_security
[![Pub](https://img.shields.io/pub/v/galileo_file_security.svg)](https://pub.dartlang.org/packages/galileo_file_security)
[![build status](https://travis-ci.org/galileo-dart/file_security.svg)](https://travis-ci.org/galileo-dart/file_security)

Middleware for securing file uploads. 

Supports:
* Max file sizes
* Max # of uploaded files
* Restrict to certain extensions
* Restrict to certain content types
* Virus scan uploaded files via [VirusTotal](https://www.virustotal.com)*

Your file upload API's can also be protected with `throttleRequests`
from [`galileo_security`](https://pub.dartlang.org/packages/galileo_security).

**Note*: See VirusTotal's [TOS](https://www.virustotal.com/about/terms-of-service/). They do not allow use of their public API in commercial products. However, you can pay to use their private API.

# Usage
```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_file_security/galileo_file_security.dart';
import 'package:http/http.dart' as http;

Future configureServer(galileo app) async {
  var middleware = restrictFileUploads(
    maxFiles: 3,
    maxFileSize: 2000,
    allowedExtensions: ['.jpg', '.png', '.gif'],
    allowedContentTypes: ['image/jpeg', 'image/png', 'image/gif'],
  );
  
  var virusScanner = new VirusTotalScanner(
    '<your-api-key>',
    new http.Client(),
  );
  
  app
    .chain([middleware, virusScanner.handleRequest])
    .post('/api/upload', (req, res) {
      // Secure...
    });
}
```
