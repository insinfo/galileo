import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'transform.dart';

/// Serializes the current time to `e.data` or `e.result`.
/// You can provide an [assign] function to set the property on your object, and skip reflection.
/// If [serialize] is `true` (default), then the set date will be a `String`. If not, a raw `DateTime` will be used.
///
/// Default key: `createdAt`
HookedServiceEventListener<Id, Data, Service<Id, Data>>
    addTimestampToData<Id, Data>(
        {FutureOr<Data> Function(Data, DateTime) assign, condition}) {
  return transform((d) => assign(d, DateTime.now().toUtc()),
      condition: condition);
}
