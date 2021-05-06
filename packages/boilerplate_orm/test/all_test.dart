import 'package:galileo/galileo.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_test/galileo_test.dart';
import 'package:test/test.dart';

/// `package:galileo_test` provides several helper utilities to make it easier
/// to test Galileo applications, and ensure that they are functioning up to par.
///
/// https://github.com/galileo-dart/test
main() {
  // Use a `TestClient` to interact with your application.
  TestClient client;

  setUp(() async {
    // Reproduce the server we defined earlier.
    var app = new Galileo();
    await app.configure(configureServer);
    client = await connectTo(app);
  });

  tearDown(() => client.close());

  test('/greet/:name endpoint returns the right greeting', () async {
    // Ensure that the server sends JSON that equals 'Hello, john!'.
    var response = await client.get('/greet/john');
    print('Response: ${response.body}');
    expect(response, isJson('Hello, john!'));
  });
}
