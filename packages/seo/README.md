# seo
[![Pub](https://img.shields.io/pub/v/galileo_seo.svg)](https://pub.dartlang.org/packages/galileo_seo)
[![build status](https://travis-ci.org/galileo-dart/seo.svg?branch=master)](https://travis-ci.org/galileo-dart/seo)

Helpers for building SEO-friendly Web pages in Galileo. The goal of
`package:galileo_seo` is to speed up perceived client page loads, prevent
the infamous
[flash of unstyled content](https://en.wikipedia.org/wiki/Flash_of_unstyled_content),
and other SEO optimizations that can easily become tedious to perform by hand.

## Disabling inlining per-element
Add a `data-no-inline` attribute to a `link` or `script` to prevent inlining it:

```html
<script src="main.dart.js" data-no-inline></script>
```

## `inlineAssets`
A
[response finalizer](https://galileo-dart.gitbook.io/galileo/the-basics/request-lifecycle)
that can be used in any application to patch HTML responses, including those sent with
a templating engine like Jael.

In any `text/html` response sent down, `link` and `script` elements that point to internal resources
will have the contents of said file read, and inlined into the HTML page itself.

In this case, "internal resources" refers to a URI *without* a scheme, i.e. `/site.css` or
`foo/bar/baz.js`.

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_seo/galileo_seo.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/local.dart';

main() async {
  var app = new Galileo()..lazyParseBodies = true;
  var fs = const LocalFileSystem();
  var http = new GalileoHttp(app);

  app.responseFinalizers.add(inlineAssets(fs.directory('web')));

  app.use(() => throw new GalileoHttpException.notFound());

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
```

## `inlineAssetsFromVirtualDirectory`
This function is a simple one; it wraps a `VirtualDirectory` to patch the way it sends
`.html` files.

Produces the same functionality as `inlineAssets`.

```dart
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_seo/galileo_seo.dart';
import 'package:galileo_static/galileo_static.dart';
import 'package:file/local.dart';

main() async {
  var app = new Galileo()..lazyParseBodies = true;
  var fs = const LocalFileSystem();
  var http = new GalileoHttp(app);

  var vDir = inlineAssets(
    new VirtualDirectory(
      app,
      fs,
      source: fs.directory('web'),
    ),
  );

  app.use(vDir.handleRequest);

  app.use(() => throw new GalileoHttpException.notFound());

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
```
