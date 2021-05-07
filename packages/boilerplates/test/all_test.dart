import 'package:galileo/galileo.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:test/test.dart';

// Galileo also includes facilities to make testing easier.
//
// `package:galileo_test` ships a client that can test
// both plain HTTP and WebSockets.
//
// Tests do not require your server to actually be mounted on a port,
// so they will run faster than they would in other frameworks, where you
// would have to first bind a socket, and then account for network latency.
//
// See the documentation here:
// https://github.com/insinfo/galileo/test
//
// If you are unfamiliar with Dart's advanced testing library, you can read up
// here:
// https://github.com/dart-lang/test

main() async {
  TestClient client;

  setUp(() async {
    var app = Galileo();
    await app.configure(configureServer);

    client = await connectTo(app);
  });

  tearDown(() async {
    await client.close();
  });

  test('index returns 200', () async {
    // Request a resource at the given path.
    var response = await client.get(Uri.parse('/'));

    // Expect a 200 response.
    expect(response, hasStatus(200));
  });
}
