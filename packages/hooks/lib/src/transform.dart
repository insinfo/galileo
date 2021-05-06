import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';

/// Mutates `e.data` or `e.result` using the given [transformer].
///
/// You can optionally provide a [condition], which can be:
/// * A [Providers] instance, or String, to run only on certain clients
/// * The type [Providers], in which case the transformer will run on every client, but *not* on server-side events.
/// * A function: if the function returns `true` (sync or async, doesn't matter),
/// then the transformer will run. If not, the event will be skipped.
/// * An [Iterable] of the above three.
///
/// A provided function must take a [HookedServiceEvent] as its only parameter.
HookedServiceEventListener<Id, Data, Service<Id, Data>> transform<Id, Data>(
    FutureOr<Data> Function(Data) transformer,
    {condition}) {
  var cond = condition is Iterable
      ? condition
      : (condition == null ? [] : [condition]);

  Future<bool> _condition(HookedServiceEvent e, condition) async {
    if (condition is FutureOr<bool> Function(dynamic))
      return await condition(e);
    else if (condition == Providers)
      return true;
    else {
      if (e.params?.containsKey('provider') == true) {
        var provider = e.params['provider'] as Providers;
        if (condition is Providers)
          return condition == provider;
        else
          return condition.toString() == provider.via;
      } else {
        return false;
      }
    }
  }

  Future<Data> normalize(HookedServiceEvent e, Data obj) async {
    bool transform = true;

    for (var c in cond) {
      var r = _condition(e, c);

      if (r != true) {
        transform = false;
        break;
      }
    }

    if (transform != true) {
      return obj;
    }

    if (obj == null)
      return null;
    else
      return await transformer(obj);
  }

  return (e) async {
    if (e.isBefore) {
      e.data = await normalize(e, e.data);
    } else if (e.isAfter) {
      e.result = await normalize(e, e.result);
    }
  };
}
