#!/usr/bin/env dart

library galileo_cli.tool;

import "dart:io";
import "package:args/command_runner.dart";
import 'package:galileo_cli/galileo_cli.dart';
import 'package:io/ansi.dart';

final String DOCTOR = "doctor";

main(List<String> args) async {
  var runner = new CommandRunner("galileo",
      asciiArt.trim() + '\n\n' + "Command-line tools for the Galileo framework." + '\n\n' + 'https://galileodart.com');

  runner.argParser.addFlag('verbose', help: 'Print verbose output.', negatable: false);

  runner
    ..addCommand(new DeployCommand())
    ..addCommand(new DoctorCommand())
    ..addCommand(new KeyCommand())
    ..addCommand(new InitCommand())
    ..addCommand(new InstallCommand())
    ..addCommand(new RenameCommand())
    ..addCommand(new MakeCommand());

  return await runner.run(args).catchError((exc, st) {
    if (exc is String) {
      stdout.writeln(exc);
    } else {
      stderr.writeln("Oops, something went wrong: $exc");
      if (args.contains('--verbose')) {
        stderr.writeln(st);
      }
    }

    exitCode = 1;
  }).whenComplete(() {
    stdout.write(resetAll.wrap(''));
  });
}

const String asciiArt = '''
   _____          _      _____ _      ______ ____  
  / ____|   /\   | |    |_   _| |    |  ____/ __ \ 
 | |  __   /  \  | |      | | | |    | |__ | |  | |
 | | |_ | / /\ \ | |      | | | |    |  __|| |  | |
 | |__| |/ ____ \| |____ _| |_| |____| |___| |__| |
  \_____/_/    \_\______|_____|______|______\____/ 
                                                                                           
''';
