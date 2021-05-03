// ignore_for_file: unawaited_futures
import 'package:lumberjack/lumberjack.dart';
import 'package:lumberjack/io.dart';

main() async {
  var logger = new Logger('example');
  var foo = logger.createChild('foo');

  var printer = new AnsiLogPrinter.toStdout();

  printer.addStream(logger);

  foo.runZoned(
    () async {
      Logger.current
        ..emergency('Nooo! It\'s THREE!!!')
        ..notice('Wait, it\'s actually okay.')
        ..debug('Ok...')
        ..warning('Don\'t do that!!! At least, not yet...');

      print('Calls to print are captured, too!');

      throw new StateError('Errors are logged, too.');
    },
    onError: () => print('caught error...'),
  );

  foo.createChild('bar').createChild('baz').notice('Hooray!');

  await logger.done;
}
