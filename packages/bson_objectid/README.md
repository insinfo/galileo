# bson_objectid

[![Build Status](https://travis-ci.org/kseo/bson_objectid.svg?branch=master)](https://travis-ci.org/kseo/bson_objectid)

BSON [ObjectId][objectid] implementation in Dart.

This package allows you to create and parse ObjectIds without
a reference to the mongodb or bson packages.

[objectid]: https://docs.mongodb.com/manual/reference/method/ObjectId/

## Example

```dart
import 'package:bson_objectid/bson_objectid.dart';

main() {
  ObjectId id1 = new ObjectId();
  print(id1.toHexString());

  ObjectId id2 = new ObjectId.fromHexString('54495ad94c934721ede76d90');
  print(id2.timestamp);
  print(id2.machineId);
  print(id2.processId);
  print(id2.counter);
}
```

