/// Browser WebSocket client library for the Galileo framework.
library galileo_websocket.browser;

import 'dart:async';
import 'dart:html';
import 'package:galileo_client/galileo_client.dart';
import 'package:galileo_http_exception/galileo_http_exception.dart';
import 'package:http/browser_client.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';
import 'base_websocket_client.dart';
export 'galileo_websocket.dart';

final RegExp _straySlashes = RegExp(r"(^/)|(/+$)");

/// Queries an Galileo server via WebSockets.
class WebSockets extends BaseWebSocketClient {
  final List<BrowserWebSocketsService> _services = [];

  WebSockets(baseUrl, {bool reconnectOnClose = true, Duration reconnectInterval})
      : super(http.BrowserClient(), baseUrl, reconnectOnClose: reconnectOnClose, reconnectInterval: reconnectInterval);

  @override
  Future close() {
    for (var service in _services) {
      service.close();
    }

    return super.close();
  }

  @override
  Stream<String> authenticateViaPopup(String url, {String eventName = 'token', String errorMessage}) {
    var ctrl = StreamController<String>();
    var wnd = window.open(url, 'galileo_client_auth_popup');

    Timer t;
    StreamSubscription<Event> sub;
    t = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!ctrl.isClosed) {
        if (wnd.closed) {
          ctrl.addError(GalileoHttpException.notAuthenticated(
              message: errorMessage ?? 'Authentication via popup window failed.'));
          ctrl.close();
          timer.cancel();
          sub?.cancel();
        }
      } else
        timer.cancel();
    });

    sub = window.on[eventName ?? 'token'].listen((e) {
      if (!ctrl.isClosed) {
        ctrl.add((e as CustomEvent).detail.toString());
        t.cancel();
        ctrl.close();
        sub.cancel();
      }
    });

    return ctrl.stream;
  }

  @override
  Future<WebSocketChannel> getConnectedWebSocket() {
    var url = websocketUri;

    if (authToken?.isNotEmpty == true) {
      url = url.replace(queryParameters: Map<String, String>.from(url.queryParameters)..['token'] = authToken);
    }

    var socket = WebSocket(url.toString());
    var completer = Completer<WebSocketChannel>();

    socket
      ..onOpen.listen((_) {
        if (!completer.isCompleted) return completer.complete(HtmlWebSocketChannel(socket));
      })
      ..onError.listen((e) {
        if (!completer.isCompleted) return completer.completeError(e is ErrorEvent ? e.error : e);
      });

    return completer.future;
  }

  @override
  BrowserWebSocketsService<Id, Data> service<Id, Data>(String path,
      {Type type, GalileoDeserializer<Data> deserializer}) {
    String uri = path.replaceAll(_straySlashes, '');
    return BrowserWebSocketsService<Id, Data>(socket, this, uri, deserializer: deserializer);
  }
}

class BrowserWebSocketsService<Id, Data> extends WebSocketsService<Id, Data> {
  final Type type;

  BrowserWebSocketsService(WebSocketChannel socket, WebSockets app, String uri,
      {this.type, GalileoDeserializer<Data> deserializer})
      : super(socket, app, uri, deserializer: deserializer);
}
