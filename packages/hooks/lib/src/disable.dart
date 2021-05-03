import 'package:angel_framework/angel_framework.dart';

/// Disables a service method for client access from a provider.
///
/// [provider] can be either a String, [Providers], an Iterable of String, or a
/// function that takes a [HookedServiceEvent] and returns a bool.
/// Futures are allowed.
///
/// If [provider] is `null`, then it will be disabled to all clients.
HookedServiceEventListener disable({provider, String errorMessage}) {
  AngelHttpException _exc() {
    if (errorMessage == null) return AngelHttpException.methodNotAllowed();
    return AngelHttpException(405, message: errorMessage);
  }

  return (HookedServiceEvent e) {
    if (e.params.containsKey('provider')) {
      if (provider == null)
        throw _exc();
      else if (provider is Function) {
        var r = provider(e);
        if (r != true) throw _exc();
      } else {
        _provide(p) => p is Providers ? p : new Providers(p.toString());

        var providers = provider is Iterable
            ? provider.map(_provide)
            : [_provide(provider)];

        if (providers.any((Providers p) => p == e.params['provider']))
          throw _exc();
      }
    }
  };
}
