library eventsource_dart.src.encoder;

import "dart:convert";
import "dart:io";

import "event.dart";
import "proxy_sink.dart";

class EventSourceEncoder extends Converter<Event, List<int>> {
  final bool compressed;

  const EventSourceEncoder({bool this.compressed: false});

  static Map<String, Function> _fields = {
    "id: ": (e) => e.id,
    "event: ": (e) => e.event,
    "data: ": (e) => e.data,
  };

  @override
  List<int> convert(Event event) {
    String payload = convertToString(event);
    List<int> bytes = utf8.encode(payload);
    if (compressed) {
      bytes = GZIP.encode(bytes);
    }
    return bytes;
  }

  String convertToString(Event event) {
    String payload = "";
    for (String prefix in _fields.keys) {
      String value = _fields[prefix](event);
      if (value == null || value.isEmpty) {
        continue;
      }
      // multi-line values need the field prefix on every line
      value = value.replaceAll("\n", "\n$prefix");
      payload += prefix + value + "\n";
    }
    payload += "\n";
    return payload;
  }

  @override
  Sink<Event> startChunkedConversion(Sink<List<int>> sink) {
    Sink inputSink = sink;
    if (compressed) {
      inputSink = GZIP.encoder.startChunkedConversion(inputSink);
    }
    inputSink = utf8.encoder.startChunkedConversion(inputSink);
    return new ProxySink(
        onAdd: (Event event) => inputSink.add(convertToString(event)), onClose: () => inputSink.close());
  }
}
