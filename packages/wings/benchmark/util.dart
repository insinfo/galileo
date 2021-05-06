import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_wings/galileo_wings.dart';
import 'package:io/ansi.dart';
import 'package:tuple/tuple.dart';

Future<Process> _runWrk(
    {ProcessStartMode mode = ProcessStartMode.inheritStdio}) async {
  return await Process.start('wrk', ['http://localhost:$testPort'], mode: mode);
}

Future<void> _warmUp() async {
  var wrk = await _runWrk();
  await wrk.exitCode;
  // await wrk.stderr.drain();
  // await wrk.stdout.drain();
}

Future _10s() => Future.delayed(Duration(seconds: 10));

const testPort = 8877;

Future<void> runBenchmarks(Iterable<GalileoBenchmark> benchmarks,
    {Iterable<String> factories = const [
      // 'galileo_http',
      'galileo_wings',
    ]}) async {
  for (var benchmark in benchmarks) {
    print(magenta.wrap('Entering benchmark: ${benchmark.name}'));

    // // Run dart:io
    // print(lightGray.wrap('Booting dart:io server (waiting 10s)...'));
    // var isolates = <Isolate>[];
    // for (int i = 0; i < Platform.numberOfProcessors; i++) {
    //   isolates.add(await Isolate.spawn(_httpIsolate, benchmark));
    // }

    // await _10s();
    // print(lightGray.wrap('Warming up dart:io server...'));
    // await _warmUp();

    // stdout
    //   ..write(lightGray.wrap('Now running `wrk` for '))
    //   ..write(cyan.wrap(benchmark.name))
    //   ..writeln(lightGray.wrap(' (waiting 10s)...'));
    // var wrk = await _runWrk(mode: ProcessStartMode.inheritStdio);
    // await wrk.exitCode;
    // isolates.forEach((i) => i.kill(priority: Isolate.immediate));

    // Run Galileo HTTP, Wings
    for (var fac in factories) {
      print(lightGray.wrap('Booting $fac server...'));

      var isolates = <Isolate>[];
      for (int i = 0; i < Platform.numberOfProcessors; i++) {
        isolates
            .add(await Isolate.spawn(_galileoIsolate, Tuple2(benchmark, fac)));
      }

      await _10s();
      print(lightGray.wrap('Warming up $fac server...'));
      await _warmUp();
      stdout
        ..write(lightGray.wrap('Now running `wrk` for '))
        ..write(cyan.wrap(benchmark.name))
        ..writeln(lightGray.wrap('...'));
      var wrk = await _runWrk(mode: ProcessStartMode.inheritStdio);
      await wrk.exitCode;
    }
  }

  exit(0);
}

void _httpIsolate(GalileoBenchmark benchmark) {
  Future(() async {
    var raw = await HttpServer.bind(InternetAddress.loopbackIPv4, testPort,
        shared: true);
    raw.listen((r) => benchmark.rawHandler(r, r.response));
  });
}

void _galileoIsolate(Tuple2<GalileoBenchmark, String> args) {
  Future(() async {
    var app = Galileo();
    Driver driver;

    if (args.item2 == 'galileo_http') {
      driver = GalileoHttp.custom(app, startShared);
    } else if (args.item2 == 'galileo_wings') {
      driver = GalileoWings.custom(app, startSharedWings);
    }

    await app.configure(args.item1.setupGalileo);
    await driver.startServer(InternetAddress.loopbackIPv4, testPort);
  });
}

abstract class GalileoBenchmark {
  const GalileoBenchmark();

  String get name;

  FutureOr<void> setupGalileo(Galileo app);

  FutureOr<void> rawHandler(HttpRequest req, HttpResponse res);
}
