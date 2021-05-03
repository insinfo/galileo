import 'package:angel_admin/angel_admin.dart';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_file_service/angel_file_service.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

main() async {
  hierarchicalLoggingEnabled = true;
  var app = new Angel();
  var http = new AngelHttp(app);
  var auth = new AngelAuth<String>(jwtKey: 'abcdefghijklmnopqrstuvwxyzABCDEFG');
  var fs = const LocalFileSystem();
  app.logger = new Logger('admin')
    ..level = Level.FINEST
    ..onRecord.listen(print);
  auth.serializer = (id) => id;
  auth.deserializer = (id) => id.toString();

  app.use(auth.decodeJwt);

  auth.strategies.add(
    new LocalAuthStrategy(
      (username, password) async =>
          (username == 'test' && password == 'admin') ? 'hello' : null,
      forceBasic: true,
    ),
  );

  var todoService = app.use(
      '/api/todos', new JsonFileService(fs.file('.todos_db.json'))) as Service;

  var admin = new Admin<String>(
    fileSystem: fs,
    configuration: new AdminConfiguration(
      title: 'Todo List Admin',
      auth: auth,
      getUsername: (u) => u,
      middleware: [
        auth.authenticate(
          'local',
          new AngelAuthOptions(
            callback: (req, res, jwt) => true,
          ),
        ),
        forceBasicAuth(),
      ],
      services: {
        'todos': new ServiceConfiguration(
          name: 'Todos',
          icon: 'shopping_cart',
          service: todoService,
          fields: {
            'text': const TextField(placeholder: 'Todo text'),
          },
        ),
      },
    ),
  );

  await app.configure(admin.configureServer(publicPath: '/admin'));

  app.use(() => throw new AngelHttpException.notFound());

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
