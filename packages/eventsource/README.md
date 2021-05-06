# eventsource
Server-sent Events (SSE) plugin for Galileo.

## Installation
In your `pubspec.yaml`:

```yaml
dependencies:
    galileo_eventsource: ^1.0.0
```

## Usage
SSE and WebSockets are somewhat similar in that they allow pushing of events from server
to client. SSE is not bi-directional, but the same abstractions used for WebSockets can be
applied to SSE easily.

For this reason, the `GalileoEventSourcePublisher` class is a simple adapter that
hands control of SSE requests to an existing `GalileoWebSocket` driver.

So, using this is pretty straightforward. You can dispatch events
via WebSocket as per usual, and have them propagated to SSE clients
as well.

```dart
var app = new Galileo();
var ws = new GalileoWebSocket(app);
var events = new GalileoEventSourcePublisher(ws);

await app.configure(ws.configureServer);

app.all('/ws', ws.handleRequest);
app.get('/events', events.handleRequest);
```
