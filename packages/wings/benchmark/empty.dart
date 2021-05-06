import 'dart:async';
import 'dart:io';
import 'package:galileo_framework/galileo_framework.dart';
import 'util.dart';

const GalileoBenchmark emptyBenchmark = _EmptyBenchmark();

main() => runBenchmarks([emptyBenchmark]);

class _EmptyBenchmark implements GalileoBenchmark {
  const _EmptyBenchmark();

  @override
  String get name => 'empty';

  @override
  FutureOr<void> rawHandler(HttpRequest req, HttpResponse res) {
    return res.close();
  }

  @override
  void setupGalileo(Galileo app) {}
}
