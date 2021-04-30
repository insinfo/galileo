library sqljocky.close_statement_handler;

import 'package:galileo_sqljocky5/constants.dart';
import 'package:galileo_typed_buffer/galileo_typed_buffer.dart';
import '../handlers/handler.dart';

class CloseStatementHandler extends Handler {
  final int? _handle;

  CloseStatementHandler(int? this._handle);

  Uint8List createRequest() {
    var buffer = FixedWriteBuffer(5);
    buffer.byte = COM_STMT_CLOSE;
    buffer.uint32 = _handle!;
    return buffer.data;
  }
}
