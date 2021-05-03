# Deployment-to-AppEngine

You can use [`package:appengine`](https://pub.dartlang.org/packages/appengine) with Angel easily, just by passing it your app's `handleRequest` method:

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:appengine/appengine.dart';

void main() async {
  var app = new Angel();
  var http = new AngelHttp(app);
  // ...

  await runAppEngine(http.handleRequest);
}
```

 