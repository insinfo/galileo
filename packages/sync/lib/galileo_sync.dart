import 'dart:async';
import 'package:galileo_websocket/galileo_websocket.dart';
import 'package:galileo_pub_sub/galileo_pub_sub.dart' as pub_sub;
import 'package:stream_channel/stream_channel.dart';

/// Synchronizes WebSockets using `package:galileo_pub_sub`.
class PubSubSynchronizationChannel extends StreamChannelMixin<WebSocketEvent> {
  /// The event name used to synchronize events on the server.
  static const String eventName = 'galileo_sync::event';

  final StreamChannelController<WebSocketEvent> _ctrl = new StreamChannelController<WebSocketEvent>();

  pub_sub.ClientSubscription _subscription;

  final pub_sub.Client client;

  PubSubSynchronizationChannel(this.client) {
    _ctrl.local.stream.listen((e) {
      return client.publish(eventName, e.toJson()).catchError(_ctrl.local.sink.addError);
    });

    client.subscribe(eventName).then((sub) {
      _subscription = sub
        ..listen((data) {
          // Incoming is a Map
          if (data is Map) {
            var e = new WebSocketEvent.fromJson(data);
            _ctrl.local.sink.add(e);
          }
        }, onError: _ctrl.local.sink.addError);
    }).catchError(_ctrl.local.sink.addError);
  }

  @override
  Stream<WebSocketEvent> get stream => _ctrl.foreign.stream;

  StreamSink<WebSocketEvent> get sink => _ctrl.foreign.sink;

  Future close() {
    if (_subscription != null) {
      _subscription.unsubscribe().then((_) => client.close());
    } else
      client.close();
    return _ctrl.local.sink.close();
  }
}
