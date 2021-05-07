import 'dart:async';

import 'package:async/async.dart';
import 'package:galileo_dart_language_server/src/stream_transform/tap.dart';
import 'package:stream_channel/stream_channel.dart';

class WireLog {
  StringSink _log;

  void attach(StringSink log) {
    _log = log;
  }

  StreamChannelTransformer<String, String> _transformer;
  StreamChannelTransformer<String, String> get transformer =>
      _transformer ??
      StreamChannelTransformer(_tapLog('In'), StreamSinkTransformer.fromStreamTransformer(_tapLog('Out')));

  _tapLog(String prefix) =>
      tap<String>((data) => _log?.writeln('$prefix: $data'), onDone: () => _log?.writeln('$prefix: Closed'));

  //tap<T>(void Function(dynamic) data, {void Function() onDone}) {}

}
