import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_task/angel_task.dart';

main() async {
  var app = await createApp();
  var scheduler = new AngelTaskScheduler(app);

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

Future<Angel> createApp() async {
  var app = new Angel();
  app.container.singleton(new Todo(text: 'Clean your room!'));
  return app;
}

class Todo {
  final String text;
  final bool completed;

  Todo({this.text, this.completed: false});
}
