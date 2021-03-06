# Configuring-SSL

The `GalileoHttp.secure` and `GalileoHttp.fromSecurityContext` constructors allow you to run servers that listen to HTTPS requests, which is great in cases where your application handles sensitive data.

You'll need a public and private key, in PEM format:

```dart
var context = new SecurityContext()
    ..useCertificateChain('keys/server.crt')
    ..usePrivateKey('keys/server.key');
var http = new GalileoHttp.fromSecurityContext(context);
```

However, a single GalileoHttp instance only corresponds to one `HttpServer` instance. To handle secure requests, while also redirecting insecure users to our HTTPS server, you'll need to have a server listening at port 80.

The easiest way to do this is to use the `forceHttps()` function from `package:galileo_multiserver`. This returns a [middleware](../the-basics/middleware.md) that sends `302` redirects from plain HTTP URL's to their HTTPS counterparts.

```dart
/// Redirect HTTP URL's to their HTTPS counterparts...
enforceHttps() async {
  var enforcer = new Galileo()..use(forceHttps());
  var http = new GalileoHttp(enforcer);
  var server = await http.startServer('0.0.0.0', 80);
  print(
      'HTTPS enforcer listening at http://${server.address.address}:${server.port}');
}
```

An example of this setup can be found here: [https://github.com/galileo-example/ssl\_multiserver/blob/master/bin/server.dart](https://github.com/galileo-example/ssl_multiserver/blob/master/bin/server.dart)

 
