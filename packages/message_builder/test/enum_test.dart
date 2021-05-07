import 'package:test/test.dart';

import 'goldens/enum.dart';

void main() {
  group('enum', () {
    test('deserialize', () {
      final serialized = {'enumField': 1};
      expect(MessageUsingEnum.fromJson(serialized),
          MessageUsingEnum((b) => b..enumField = SomeEnum.someValue));
    });

    test('serialize', () {
      final message =
          MessageUsingEnum((b) => b..enumField = SomeEnum.anotherValue);
      expect(message.toJson(), {'enumField': 2});
    });
  });
}
