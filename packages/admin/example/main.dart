import 'package:galileo_admin/galileo_admin.dart';
import 'package:galileo_auth/galileo_auth.dart';
import 'package:galileo_file_service/galileo_file_service.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:file/local.dart';
import 'package:logging/logging.dart';

main() async {
  hierarchicalLoggingEnabled = true;
  var app = new Galileo();
  var http = new GalileoHttp(app);
  var auth = new GalileoAuth<String>(jwtKey: 'abcdefghijklmnopqrstuvwxyzABCDEFG');
  var fs = const LocalFileSystem();
  app.logger = new Logger('admin')
    ..level = Level.FINEST
    ..onRecord.listen(print);
  auth.serializer = (id) => id;
  auth.deserializer = (id) => id.toString();

  app.use(auth.decodeJwt);

  auth.strategies.add(
    new LocalAuthStrategy(
      (username, password) async => (username == 'test' && password == 'admin') ? 'hello' : null,
      forceBasic: true,
    ),
  );

  var todoService = app.use('/api/todos', new JsonFileService(fs.file('.todos_db.json'))) as Service;

  var admin = new Admin<String>(
    fileSystem: fs,
    configuration: new AdminConfiguration(
      title: 'Todo List Admin',
      auth: auth,
      getUsername: (u) => u,
      middleware: [
        auth.authenticate(
          'local',
          new galileoAuthOptions(
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

  app.use(() => throw new galileoHttpException.notFound());

  var server = await http.startServer('127.0.0.1', 3000);
  print('Listening at http://${server.address.address}:${server.port}');
}
