// ignore_for_file: unawaited_futures
import 'package:logging/logging.dart';
import 'package:lumberjack/io.dart';
import 'package:lumberjack/logging.dart';

main() async {
  var logger = new Logger('example');
  var converter = new ConvertingLogger(logger);
  converter.pipe(new AnsiLogPrinter.toStdout());

  logger.info('Hellooooooo!!!!');
  logger.severe('Compatibility is GREAT!');
  converter.notice('We can still use the converter directly.');

  await converter.done;
}
