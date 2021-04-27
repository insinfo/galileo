import 'dart:async';
import 'dart:convert';
import 'dart:io' show Cookie, HttpRequest, HttpResponse, HttpServer, Platform, SecurityContext;
import 'package:galileo_framework/galileo_framework.dart';
import '../core/core.dart';
import 'http_request_context.dart';
import 'http_response_context.dart';

final RegExp _straySlashes = RegExp(r'(^/+)|(/+$)');

/// Adapts `dart:io`'s [HttpServer] to serve Galileo.
class GalileoHttp extends Driver<HttpRequest, HttpResponse, HttpServer, HttpRequestContext, HttpResponseContext> {
  @override
  Uri get uri => server == null ? Uri() : Uri(scheme: 'http', host: server.address.address, port: server.port);

  GalileoHttp._(Galileo app, Future<HttpServer> Function(dynamic, int) serverGenerator, bool useZone)
      : super(app, serverGenerator, useZone: useZone);

  factory GalileoHttp(Galileo app, {bool useZone = true}) {
    return GalileoHttp._(app, HttpServer.bind, useZone);
  }

  /// An instance mounted on a server started by the [serverGenerator].
  factory GalileoHttp.custom(Galileo app, Future<HttpServer> Function(dynamic, int) serverGenerator,
      {bool useZone = true}) {
    return GalileoHttp._(app, serverGenerator, useZone);
  }

  factory GalileoHttp.fromSecurityContext(Galileo app, SecurityContext context, {bool useZone = true}) {
    return GalileoHttp._(app, (address, int port) {
      return HttpServer.bindSecure(address, port, context);
    }, useZone);
  }

  /// Creates an HTTPS server.
  ///
  /// Provide paths to a certificate chain and server key (both .pem).
  /// If no password is provided, a random one will be generated upon running
  /// the server.
  factory GalileoHttp.secure(Galileo app, String certificateChainPath, String serverKeyPath,
      {String password, bool useZone = true}) {
    var certificateChain = Platform.script.resolve(certificateChainPath).toFilePath();
    var serverKey = Platform.script.resolve(serverKeyPath).toFilePath();
    var serverContext = SecurityContext();
    serverContext.useCertificateChain(certificateChain, password: password);
    serverContext.usePrivateKey(serverKey, password: password);
    return GalileoHttp.fromSecurityContext(app, serverContext, useZone: useZone);
  }

  /// Use [server] instead.
  @deprecated
  HttpServer get httpServer => server;

  Future handleRequest(HttpRequest request) => handleRawRequest(request, request.response);

  @override
  void addCookies(HttpResponse response, Iterable<Cookie> cookies) => response.cookies.addAll(cookies);

  @override
  Future<HttpServer> close() async {
    await server?.close();
    return await super.close();
  }

  @override
  Future closeResponse(HttpResponse response) => response.close();

  @override
  Future<HttpRequestContext> createRequestContext(HttpRequest request, HttpResponse response) {
    var path = request.uri.path.replaceAll(_straySlashes, '');
    if (path.isEmpty) path = '/';
    return HttpRequestContext.from(request, app, path);
  }

  @override
  Future<HttpResponseContext> createResponseContext(HttpRequest request, HttpResponse response,
      [HttpRequestContext correspondingRequest]) {
    return Future<HttpResponseContext>.value(HttpResponseContext(response, app, correspondingRequest)
      ..serializer = (app.serializer ?? json.encode)
      ..encoders.addAll(app.encoders ?? {}));
  }

  @override
  Stream<HttpResponse> createResponseStreamFromRawRequest(HttpRequest request) =>
      Stream.fromIterable([request.response]);

  @override
  void setChunkedEncoding(HttpResponse response, bool value) => response.headers.chunkedTransferEncoding = value;

  @override
  void setContentLength(HttpResponse response, int length) => response.headers.contentLength = length;

  @override
  void setHeader(HttpResponse response, String key, String value) => response.headers.set(key, value);

  @override
  void setStatusCode(HttpResponse response, int value) => response.statusCode = value;

  @override
  void writeStringToResponse(HttpResponse response, String value) => response.write(value);

  @override
  void writeToResponse(HttpResponse response, List<int> data) => response.add(data);
}
