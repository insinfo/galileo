library sqljocky.use_db_handler;

import 'dart:convert';

import 'package:galileo_sqljocky5/constants.dart';
import 'package:galileo_typed_buffer/galileo_typed_buffer.dart';
import 'handler.dart';

class UseDbHandler extends Handler {
  final String _dbName;

  UseDbHandler(String this._dbName);

  Uint8List createRequest() {
    List<int> encoded = utf8.encode(_dbName);
    var buffer = FixedWriteBuffer(encoded.length + 1);
    buffer.byte = COM_INIT_DB;
    buffer.writeList(encoded);
    return buffer.data;
  }
}
