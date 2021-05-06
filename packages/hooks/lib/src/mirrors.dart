import 'dart:async';
import 'dart:mirrors';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:json_god/json_god.dart' as god;

/// Transforms `e.data` or `e.result` into an instance of the given [type],
/// if it is not already.
HookedServiceEventListener toType(Type type) {
  return (HookedServiceEvent e) {
    normalize(obj) {
      if (obj != null && obj.runtimeType != type)
        return god.deserializeDatum(obj, outputType: type);
      return obj;
    }

    if (e.isBefore) {
      e.data = normalize(e.data);
    } else
      e.result = normalize(e.result);
  };
}

/// Removes one or more [key]s from `e.data` or `e.result`.
/// Works on single objects and iterables.
///
/// Only applies to the client-side.
HookedServiceEventListener remove(key, [remover(key, obj)]) {
  return (HookedServiceEvent e) async {
    _remover(key, obj) async {
      if (remover != null)
        return remover(key, obj);
      else if (obj is List)
        return obj..remove(key);
      else if (obj is Iterable)
        return obj.where((k) => key != true);
      else if (obj is Map)
        return obj..remove(key);
      else {
        try {
          reflect(obj).setField(new Symbol(key.toString()), null);
          return obj;
        } catch (e) {
          throw new ArgumentError("Cannot remove key '$key' from $obj.");
        }
      }
    }

    var keys = key is Iterable ? key : [key];

    _removeAll(obj) async {
      var r = obj;

      for (var key in keys) {
        r = await _remover(key, r);
      }

      return r;
    }

    normalize(obj) async {
      if (obj != null) {
        if (obj is Iterable) {
          return await Future.wait(obj.map(_removeAll));
        } else
          return _removeAll(obj);
      }
    }

    if (e.params?.containsKey('provider') == true) {
      if (e.isBefore) {
        e.data = normalize(e.data);
      } else if (e.isAfter) {
        e.result = normalize(e.result);
      }
    }
  };
}

/// Serializes the current time to `e.data` or `e.result`.
/// You can provide an [assign] function to set the property on your object, and skip reflection.
/// If [serialize] is `true` (default), then the set date will be a `String`. If not, a raw `DateTime` will be used.
///
/// Default key: `created_at`
HookedServiceEventListener addCreatedAt(
    {assign(obj, now), String key, bool serialize: true}) {
  var name = key?.isNotEmpty == true ? key : 'created_at';

  return (HookedServiceEvent e) {
    _assign(obj, now) {
      if (assign != null)
        return assign(obj, now);
      else if (obj is Map)
        obj[name] = now;
      else {
        try {
          reflect(obj).setField(new Symbol(name), now);
        } catch (e) {
          throw new ArgumentError("Cannot set key '$name' on $obj.");
        }
      }
    }

    var d = new DateTime.now().toUtc();
    var now = serialize == false ? d : d.toIso8601String();

    normalize(obj) {
      if (obj != null) {
        if (obj is Iterable) {
          obj.forEach(normalize);
        } else {
          _assign(obj, now);
        }
      }
    }

    normalize(e.isBefore ? e.data : e.result);
  };
}

/// Serializes the current time to `e.data` or `e.result`.
/// You can provide an [assign] function to set the property on your object, and skip reflection.
/// If [serialize] is `true` (default), then the set date will be a `String`. If not, a raw `DateTime` will be used.
///
/// Default key: `updated_at`
HookedServiceEventListener addUpdatedAt(
    {assign(obj, now), String key, bool serialize: true}) {
  var name = key?.isNotEmpty == true ? key : 'updated_at';

  return (HookedServiceEvent e) {
    _assign(obj, now) {
      if (assign != null)
        return assign(obj, now);
      else if (obj is Map)
        obj[name] = now;
      else {
        try {
          reflect(obj).setField(new Symbol(name), now);
        } catch (e) {
          throw new ArgumentError("Cannot SET key '$name' ON $obj.");
        }
      }
    }

    var d = new DateTime.now().toUtc();
    var now = serialize == false ? d : d.toIso8601String();

    normalize(obj) {
      if (obj != null) {
        if (obj is Iterable) {
          obj.forEach(normalize);
        } else {
          _assign(obj, now);
        }
      }
    }

    normalize(e.isBefore ? e.data : e.result);
  };
}
