import 'package:angel/angel.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_test/angel_test.dart';
import 'package:test/test.dart';

/// `package:angel_test` provides several helper utilities to make it easier
/// to test Angel applications, and ensure that they are functioning up to par.
///
/// https://github.com/angel-dart/test
main() {
  // Use a `TestClient` to interact with your application.
  TestClient client;

  setUp(() async {
    // Reproduce the server we defined earlier.
    var app = new Angel();
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