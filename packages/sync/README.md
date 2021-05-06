# sync
[![Pub](https://img.shields.io/pub/v/galileo_sync.svg)](https://pub.dartlang.org/packages/galileo_sync)
[![build status](https://travis-ci.org/galileo-dart/sync.svg)](https://travis-ci.org/galileo-dart/sync)

Easily synchronize and scale WebSockets using package:pub_sub.

# Usage
This package exposes `PubSubSynchronizationChannel`, which
can simply be dropped into any `GalileoWebSocket` constructor.

Once you've set that up, instances of your application will
automatically fire events in-sync. That's all you have to do
to scale a real-time application with Galileo!

```dart
await app.configure(new GalileoWebSocket(
    synchronizationChannel: new PubSubSynchronizationChannel(
        new pub_sub.IsolateClient('<client-id>', adapter.receivePort.sendPort),
    ),
));
```
