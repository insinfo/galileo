import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
//import 'package:dart_language_server/dart_language_server.dart';
import 'package:vs_twig_language_server/twig_language_server.dart';
import 'package:vs_twig_language_server/src/protocol/language_server/server.dart';

main(List<String> args) async {
  var argParser = new ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Print this help information.')
    ..addOption('log-file', help: 'A path to which to write a log file.');

  void printUsage() {
    print('usage: twig_language_server [options...]\n\nOptions:');
    print(argParser.usage);
  }

  try {
    var argResults = argParser.parse(args);

    if (argResults['help'] as bool) {
      printUsage();
      return;
    } else {
      var twigServer = new TwigLanguageServer();

      if (argResults.wasParsed('log-file')) {
        var f = new File(argResults['log-file'] as String);
        await f.create(recursive: true);

        twigServer.logger.onRecord.listen((rec) async {
          var sink = await f.openWrite(mode: FileMode.append);
          sink.writeln(rec);
          if (rec.error != null) sink.writeln(rec.error);
          if (rec.stackTrace != null) sink.writeln(rec.stackTrace);
          await sink.close();
        });
      } else {
        twigServer.logger.onRecord.listen((rec) async {
          var sink = stderr;
          sink.writeln(rec);
          if (rec.error != null) sink.writeln(rec.error);
          if (rec.stackTrace != null) sink.writeln(rec.stackTrace);
        });
      }

      var spec = new ZoneSpecification(
        handleUncaughtError: (self, parent, zone, error, stackTrace) {
          twigServer.logger.severe('Uncaught', error, stackTrace);
        },
        print: (self, parent, zone, line) {
          twigServer.logger.info(line);
        },
      );
      var zone = Zone.current.fork(specification: spec);
      await zone.run(() async {
        var stdio = StdIOLanguageServer.start(twigServer);
        await stdio.onDone;
      });
    }
  } on ArgParserException catch (e) {
    print('${red.wrap('error')}: ${e.message}\n');
    printUsage();
    exitCode = ExitCode.usage.code;
  }
}
