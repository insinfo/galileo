# proxy
[![Pub](https://img.shields.io/pub/v/galileo_proxy.svg)](https://pub.dartlang.org/packages/galileo_proxy)
[![build status](https://travis-ci.org/galileo-dart/proxy.svg)](https://travis-ci.org/galileo-dart/proxy)

Galileo middleware to forward requests to another server (i.e. `webdev serve`).
Also supports WebSockets.

```dart
import 'package:galileo_proxy/galileo_proxy.dart';
import 'package:http/http.dart' as http;

main() async {
  // Forward requests instead of serving statically.
  // You can also pass a URI, instead of a string.
  var proxy1 = Proxy('http://localhost:3000');
  
  // handle all methods (GET, POST, ...)
  app.fallback(proxy.handleRequest);
}
```

You can also restrict the proxy to serving only from a specific root:
```dart
Proxy(baseUrl, publicPath: '/remote');
```

Also, you can map requests to a root path on the remote server:
```dart
Proxy(baseUrl.replace(path: '/path'));
```

Request bodies will be forwarded as well, if they are not empty. This allows things like POST requests to function.

For a request body to be forwarded, the body must not have already been parsed.
