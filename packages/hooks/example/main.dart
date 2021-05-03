import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_hooks/angel_hooks.dart' as hooks;
import 'package:angel_hooks/mirrors.dart' as hooks;

main() async {
  var app = Angel();
  var http = AngelHttp(app);

  // Set the service up, and hook it.
  var service = app.use('/api/todos', MapService());
  service
    ..beforeRead.listen(hooks.disable(errorMessage: 'Nope!'))
    ..beforeCreated.listen(hooks.transform((_) =>
        {'message': 'Everything in this service will be the same item!!!'}))
    ..beforeCreated.listen(hooks.chainListeners([
      hooks.addCreatedAt(),
      hooks.addUpdatedAt(),
    ]));

  await http.startServer('127.0.0.1', 3000);
  print('Listening at ${http.uri}');
}
