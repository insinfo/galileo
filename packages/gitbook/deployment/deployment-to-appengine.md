# Deployment-to-AppEngine

You can use [`package:appengine`](https://pub.dartlang.org/packages/appengine) with Galileo easily, just by passing it your app's `handleRequest` method:

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:appengine/appengine.dart';

void main() async {
  var app = new Galileo();
  var http = new GalileoHttp(app);
  // ...

  await runAppEngine(http.handleRequest);
}
```

 
