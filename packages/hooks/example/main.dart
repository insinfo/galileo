import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_framework/http.dart';
import 'package:galileo_hooks/galileo_hooks.dart' as hooks;
import 'package:galileo_hooks/mirrors.dart' as hooks;

main() async {
  var app = Galileo();
  var http = GalileoHttp(app);

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
