// Copyright (c) 2016, Kwang Yul Seo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:galileo_bson_objectid/galileo_bson_objectid.dart';

main() {
  ObjectId id1 = new ObjectId();
  print(id1.toHexString());

  ObjectId id2 = new ObjectId.fromHexString('54495ad94c934721ede76d90');
  print(id2.timestamp);
  print(id2.machineId);
  print(id2.processId);
  print(id2.counter);
}
