import 'package:angel_diagnostics/angel_diagnostics.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_test/angel_test.dart';
import 'package:angel_toggle/angel_toggle.dart';
import 'package:test/test.dart';

main() {
  Angel testApp, jimApp, normalApp;
  TestClient testAppClient, jimAppClient, normalAppClient;

  setUp(() async {
    var gregPlugin = toggleService('api/greg', () => new GregService());

    testApp = new Angel();
    await testApp.configure(gregPlugin);
    testAppClient = await connectTo(testApp);

    jimApp = new Angel();
    await jimApp.configure(toggleService(
        'api/greg', () => new GregService(), () => new JimService()));
    jimAppClient = await connectTo(jimApp);

    normalApp = new Angel()
      ..properties['testMode'] = false;
    await normalApp.configure(gregPlugin);
    normalAppClient = await connectTo(normalApp);
  });

  tearDown(() async {
    await testAppClient.close();
    await jimAppClient.close();
    await normalAppClient.close();
  });

  test('delegates to correct service', () async {
    var testResponse = await testAppClient.service('api/greg').index() as List;
    print('TEST index: $testResponse');
    expect(testResponse, isEmpty);

    var jimResponse = await jimAppClient.service('api/greg')
        .index() as List;
    print('JIM index: $jimResponse');
    expect(jimResponse, ['Jim']);

    var normalResponse = await normalAppClient.service('api/greg')
        .index() as List;
    print('NORMAL index: $normalResponse');
    expect(normalResponse, ['Greg']);
  });
}

class GregService extends Service {
  @override
  index([Map params]) async => ['Greg'];
}

class JimService extends Service {
  @override
  index([Map params]) async => ['Jim'];
}