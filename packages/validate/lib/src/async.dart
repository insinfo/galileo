import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_http_exception/galileo_http_exception.dart';
import 'package:matcher/matcher.dart';
import 'context_aware.dart';

/// Returns an [GalileoMatcher] that uses an arbitrary function that returns
/// true or false for the actual value.
///
/// Analogous to the synchronous [predicate] matcher.
GalileoMatcher predicateWithGalileo(FutureOr<bool> Function(String, Object, Galileo) f,
        [String description = 'satisfies function']) =>
    _PredicateWithGalileo(f, description);

/// Returns an [GalileoMatcher] that applies an asynchronously-created [Matcher]
/// to the input.
///
/// Use this to match values against configuration, injections, etc.
GalileoMatcher matchWithGalileo(FutureOr<Matcher> Function(Object, Map, Galileo) f,
        [String description = 'satisfies asynchronously created matcher']) =>
    _MatchWithGalileo(f, description);

/// Calls [matchWithGalileo] without the initial parameter.
GalileoMatcher matchWithGalileoBinary(FutureOr<Matcher> Function(Map context, Galileo) f,
        [String description = 'satisfies asynchronously created matcher']) =>
    matchWithGalileo((_, context, app) => f(context, app));

/// Calls [matchWithGalileo] without the initial two parameters.
GalileoMatcher matchWithGalileoUnary(FutureOr<Matcher> Function(Galileo) f,
        [String description = 'satisfies asynchronously created matcher']) =>
    matchWithGalileoBinary((_, app) => f(app));

/// Calls [matchWithGalileo] without any parameters.
GalileoMatcher matchWithGalileoNullary(FutureOr<Matcher> Function() f,
        [String description = 'satisfies asynchronously created matcher']) =>
    matchWithGalileoUnary((_) => f());

/// Returns an [GalileoMatcher] that represents [x].
///
/// If [x] is an [GalileoMatcher], then it is returned, unmodified.
GalileoMatcher wrapGalileoMatcher(x) {
  if (x is GalileoMatcher) return x;
  if (x is ContextAwareMatcher) return _WrappedGalileoMatcher(x);
  return wrapGalileoMatcher(wrapContextAwareMatcher(x));
}

/// Returns an [GalileoMatcher] that asynchronously resolves a [feature], builds a [matcher], and executes it.
GalileoMatcher matchAsync(FutureOr<Matcher> Function(String, Object) matcher, FutureOr Function() feature,
    [String description = 'satisfies asynchronously created matcher']) {
  return _MatchAsync(matcher, feature, description);
}

/// Returns an [GalileoMatcher] that verifies that an item with the given [idField]
/// exists in the service at [servicePath], without throwing a `404` or returning `null`.
GalileoMatcher idExistsInService(String servicePath, {String idField = 'id', String description}) {
  return predicateWithGalileo(
    (key, item, app) async {
      try {
        var result = await app.findService(servicePath)?.read(item);
        return result != null;
      } on GalileoHttpException catch (e) {
        if (e.statusCode == 404) {
          return false;
        } else {
          rethrow;
        }
      }
    },
    description ?? 'exists in service $servicePath',
  );
}

/// An asynchronous [Matcher] that runs in the context of an [Galileo] app.
abstract class GalileoMatcher extends ContextAwareMatcher {
  Future<bool> matchesWithGalileo(item, String key, Map context, Map matchState, Galileo app);

  @override
  bool matchesWithContext(item, String key, Map context, Map matchState) {
    return true;
  }
}

class _WrappedGalileoMatcher extends GalileoMatcher {
  final ContextAwareMatcher matcher;

  _WrappedGalileoMatcher(this.matcher);

  @override
  Description describe(Description description) => matcher.describe(description);

  @override
  Future<bool> matchesWithGalileo(item, String key, Map context, Map matchState, Galileo app) async {
    return matcher.matchesWithContext(item, key, context, matchState);
  }
}

class _MatchWithGalileo extends GalileoMatcher {
  final FutureOr<Matcher> Function(Object, Map, Galileo) f;
  final String description;

  _MatchWithGalileo(this.f, this.description);

  @override
  Description describe(Description description) =>
      this.description == null ? description : description.add(this.description);

  @override
  Future<bool> matchesWithGalileo(item, String key, Map context, Map matchState, Galileo app) {
    return Future.sync(() => f(item, context, app)).then((result) {
      return result.matches(item, matchState);
    });
  }
}

class _PredicateWithGalileo extends GalileoMatcher {
  final FutureOr<bool> Function(String, Object, Galileo) predicate;
  final String description;

  _PredicateWithGalileo(this.predicate, this.description);

  @override
  Description describe(Description description) =>
      this.description == null ? description : description.add(this.description);

  @override
  Future<bool> matchesWithGalileo(item, String key, Map context, Map matchState, Galileo app) {
    return Future<bool>.sync(() => predicate(key, item, app));
  }
}

class _MatchAsync extends GalileoMatcher {
  final FutureOr<Matcher> Function(String, Object) matcher;
  final FutureOr Function() feature;
  final String description;

  _MatchAsync(this.matcher, this.feature, this.description);

  @override
  Description describe(Description description) =>
      this.description == null ? description : description.add(this.description);

  @override
  Future<bool> matchesWithGalileo(item, String key, Map context, Map matchState, Galileo app) async {
    var f = await feature();
    var m = await matcher(key, f);
    var c = wrapGalileoMatcher(m);
    return await c.matchesWithGalileo(item, key, context, matchState, app);
  }
}
