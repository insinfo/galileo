import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_task/galileo_task.dart';

main() async {
  var app = await createApp();
  var scheduler = new GalileoTaskScheduler(app);

  scheduler.once((Todo singleton) {
    print('3 seconds later, we found our Todo singleton: "${singleton.text}"');
  }, new Duration(seconds: 3));

  Task foo;
  int i = 0;

  foo = scheduler.seconds(1, () {
    print('Printing ${++i} time(s)!');

    if (i >= 3) {
      print('Cancelling foo task...');
      foo.cancel();
    }
  });

  await scheduler.start();
}

Future<Galileo> createApp() async {
  var app = new Galileo();
  app.container.singleton(new Todo(text: 'Clean your room!'));
  return app;
}

class Todo {
  final String text;
  final bool completed;

  Todo({this.text, this.completed: false});
}
