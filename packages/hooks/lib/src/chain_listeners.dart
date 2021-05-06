import 'package:galileo_framework/galileo_framework.dart';

/// Sequentially runs a set of [listeners].
HookedServiceEventListener<Id, Data, T>
    chainListeners<Id, Data, T extends Service<Id, Data>>(
        Iterable<HookedServiceEventListener> listeners) {
  return (e) async {
    for (var listener in listeners) await listener(e);
  };
}
