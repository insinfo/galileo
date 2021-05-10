// Copyright (c) 2016, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:galileo_bson_objectid/galileo_bson_objectid.dart';
import 'package:test/test.dart';

void main() {
  group('ObjectId', () {
    test('should construct with `fromBytes` constructor', () {
      final id1 = ObjectId.fromBytes([84, 73, 90, 217, 76, 147, 71, 33, 237, 231, 109, 144]);
      expect(id1.toHexString(), '54495ad94c934721ede76d90');

      final id2 = ObjectId.fromBytes([81, 6, 252, 154, 188, 130, 55, 85, 129, 54, 210, 137]);
      expect(id2.timestamp, 0x5106FC9A);
      expect(id2.machineId, 0x00BC8237);
      expect(id2.processId, 0x5581);
      expect(id2.counter, 0x0036D289);
    });

    test('should construct with `date` constructor', () {
      final d = DateTime.now();
      ObjectId id = ObjectId.fromDate(d);
      expect(d.millisecondsSinceEpoch ~/ 1000, id.date.millisecondsSinceEpoch ~/ 1000);
    });

    test('should throw an error if constructing with an invalid bytes', () {
      expect(() => ObjectId.fromBytes(null), throwsArgumentError);
      expect(() => ObjectId.fromBytes([]), throwsArgumentError);
    });

    test('should construct with `hexString` constructor', () {
      ObjectId id = ObjectId();
      expect(id, ObjectId.fromHexString(id.toHexString()));
    });

    test('should throw an error if constructing with an invalid hex string', () {
      expect(() => ObjectId.fromHexString(null), throwsArgumentError);
      expect(() => ObjectId.fromHexString(''), throwsArgumentError);
      expect(() => ObjectId.fromHexString('invalid'), throwsArgumentError);
      expect(() => ObjectId.fromHexString('zzzzzzzzzzzzzzzzzzzzzzzz'), throwsArgumentError);
      expect(() => ObjectId.fromHexString('54495-ad94c934721ede76d9'), throwsArgumentError);
    });

    test('time', () {
      final t = DateTime.now();
      final id = ObjectId();
      expect(id.date.difference(t).inMilliseconds < 3000, isTrue);
    });

    test('should increment the counter when a new object is constructed', () {
      expect(ObjectId().counter + 1 == ObjectId().counter, isTrue);
    });

    test('should validate legit ObjectId objects', () {
      final id = ObjectId();
      expect(ObjectId.isValid(id.toHexString()), isTrue);
    });

    test('should validate valid hex strings', () {
      expect(ObjectId.isValid('54495ad94c934721ede76d90'), isTrue);
      expect(ObjectId.isValid('aaaaaaaaaaaaaaaaaaaaaaaa'), isTrue);
      expect(ObjectId.isValid('AAAAAAAAAAAAAAAAAAAAAAAA'), isTrue);
      expect(ObjectId.isValid('000000000000000000000000'), isTrue);
    });

    test('should invalidate bad strings', () {
      expect(() => ObjectId.isValid(null), throwsArgumentError);
      expect(ObjectId.isValid(''), isFalse);
      expect(ObjectId.isValid('invalid'), isFalse);
      expect(ObjectId.isValid('zzzzzzzzzzzzzzzzzzzzzzzz'), isFalse);
      expect(ObjectId.isValid('54495-ad94c934721ede76d9'), isFalse);
    });

    test('should evaluate equality with ==', () {
      final id1 = ObjectId();
      final id2 = ObjectId.fromHexString(id1.toHexString());
      expect(id1, id2);

      final id3 = ObjectId();
      expect(id1, isNot(id3));
    });
  });
}
