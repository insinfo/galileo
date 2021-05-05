import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_websocket/server.dart';
import 'package:eventsource_dart/eventsource_dart.dart';
import 'package:eventsource_dart/src/encoder.dart';
import 'package:eventsource_dart/publisher.dart';
import 'package:stream_channel/stream_channel.dart';

class GalileoEventSourcePublisher {
  final GalileoWebSocket webSocketDriver;

  final String channel;

  int _count = 0;

  GalileoEventSourcePublisher(this.webSocketDriver, {this.channel: ''});

  Future handleRequest(RequestContext req, ResponseContext res) async {
    if (!req.accepts('text/event-stream', strict: false)) throw new GalileoHttpException.badRequest();

    res.headers.addAll({
      'cache-control': 'no-cache, no-store, must-revalidate',
      'content-type': 'text/event-stream',
      'connection': 'keep-alive',
    });

    var acceptsGzip = (req.headers['accept-encoding']?.contains('gzip') == true);

    if (acceptsGzip) res.headers['content-encoding'] = 'gzip';

    var eventSink = new EventSourceEncoder(compressed: acceptsGzip).startChunkedConversion(res);

    // Listen for events.
    var ctrl = new StreamChannelController();

    // Incoming events are strings, and should be sent via the eventSink.
    ctrl.local.stream.cast<String>().listen((data) {
      eventSink.add(new Event(
        id: (_count++).toString(),
        data: data,
      ));
    });

    // Create a new WebSocketContext, and hand it off to the driver.
    var socket = new WebSocketContext(ctrl.foreign, req, res);
    return await webSocketDriver.handleClient(socket);
  }
}
