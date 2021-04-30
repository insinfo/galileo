library galileo_typed_buffer.buffer;

import 'dart:typed_data';

/// This provides methods to read and write strings, lists and
/// various sized integers on a buffer (implemented as an integer list).
///
/// The ints in the backing list must all be 8-bit values. If larger values are
/// entered, behaviour is undefined.
///
/// As per mysql spec, numbers here are all unsigned.
/// Which makes things much easier.
class FixedWriteBuffer {
  int _writePos = 0;

  late ByteData _data;

  final Uint8List data;

  /// Creates a [Buffer] of the given [size]
  FixedWriteBuffer(int size) : data = new Uint8List(size) {
    _data = new ByteData.view(data.buffer);
  }

  /// Creates a [Buffer] with the given [list] as backing storage
  FixedWriteBuffer.fromList(List<int> list) : data = new Uint8List(list.length) {
    list.setRange(0, list.length, list);
    _data = new ByteData.view(data.buffer);
  }

  /// Sets the int at the specified [index] to the given [value]
  void operator []=(int index, value) {
    data[index] = value;
  }

  /// Resets the read and write positions markers to the start of
  /// the buffer.
  void resetWrite() => _writePos = 0;

  void reset() => resetWrite();

  /**
   * Returns the size of the buffer
   */
  int get length => data.length;

  /**
   * Moves the write marker to the given [position]
   */
  void seekWrite(int position) => _writePos = position;

  /**
   * Moves the write marker forwards by the given [numberOfBytes]
   */
  void skipWrite(int numberOfBytes) => _writePos += numberOfBytes;

  /**
   * Fills the next [numberOfBytes] with the given [value]
   */
  void fill(int numberOfBytes, int value) {
    while (numberOfBytes > 0) {
      byte = value;
      numberOfBytes--;
    }
  }

  /**
   * Writes a null terminated list of ints from the buffer. The given [list]
   * should not contain the terminating zero.
   */
  set nullTerminatedList(List<int> list) {
    writeList(list);
    byte = 0;
  }

  /**
   * Will write a length coded binary value, once implemented!
   */
  void writeLengthCodedBinary(int value) {
    if (value < 251) {
      byte = value;
      return;
    }
    if (value < (2 << 15)) {
      byte = 0xfc;
      uint16 = value;
      return;
    }
    if (value < (2 << 23)) {
      byte = 0xfd;
      uint24 = value;
      return;
    }
    if (value < (2 << 63)) {
      byte = 0xfe;
      uint64 = value;
    }
  }

  bool get canWriteMore => _writePos < data.length;

  /**
   * Writes a single [byte] to the buffer.
   */
  set byte(int byte) => _data.setInt8(_writePos++, byte);

  /**
   * Writes a 16 bit [integer] to the buffer.
   */
  set int16(int integer) {
    _data.setInt16(_writePos, integer, Endian.little);
    _writePos += 2;
  }

  /**
   * Writes a 16 bit [integer] to the buffer.
   */
  set uint16(int integer) {
    _data.setUint16(_writePos, integer, Endian.little);
    _writePos += 2;
  }

  /**
   * Writes a 24 bit [integer] to the buffer.
   */
  set uint24(int integer) {
    data[_writePos++] = integer & 0xFF;
    data[_writePos++] = integer >> 8 & 0xFF;
    data[_writePos++] = integer >> 16 & 0xFF;
  }

  /**
   * Writes a 32 bit [integer] to the buffer.
   */
  set int32(int integer) {
    _data.setInt32(_writePos, integer, Endian.little);
    _writePos += 4;
  }

  /**
   * Writes a 32 bit [integer] to the buffer.
   */
  set uint32(int integer) {
    _data.setUint32(_writePos, integer, Endian.little);
    _writePos += 4;
  }

  /**
   * Writes a 64 bit [integer] to the buffer.
   */
  set int64(int integer) {
    _data.setInt64(_writePos, integer, Endian.little);
    _writePos += 8;
  }

  /**
   * Writes a 64 bit [integer] to the buffer.
   */
  set uint64(int integer) {
    _data.setUint64(_writePos, integer, Endian.little);
    _writePos += 8;
  }

  /**
   * Writes the give [list] of bytes to the buffer.
   */
  void writeList(List<int> list) {
    data.setRange(_writePos, _writePos + list.length, list);
    _writePos += list.length;
  }

  set float(double value) {
    _data.setFloat32(_writePos, value, Endian.little);
    _writePos += 4;
  }

  set double_(double value) {
    _data.setFloat64(_writePos, value, Endian.little);
    _writePos += 8;
  }
}
