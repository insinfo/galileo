import 'package:test/test.dart';

import 'goldens/list_field.dart';
import 'goldens/map_field.dart';
import 'goldens/message.dart';
import 'goldens/nested_in_list.dart';
import 'goldens/nested_message.dart';
import 'goldens/subclassed_message.dart';

void main() {
  group('message', () {
    test('deserialize', () {
      final serialized = {'stringField': 'stringValue', 'intField': 1};
      expect(
          SomeMessage.fromJson(serialized),
          SomeMessage((b) => b
            ..stringField = 'stringValue'
            ..intField = 1));
    });

    test('serialize', () {
      final message = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      expect(message.toJson(), {'stringField': 'value', 'intField': 2});
    });

    test('hashCode', () {
      final message = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      final messageSame = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 2);
      final messageDifferent = SomeMessage((b) => b
        ..stringField = 'value'
        ..intField = 3);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('with list field', () {
    test('deserialize', () {
      final serialized = {
        'stringList': ['first', 'second'],
        'intList': [1, 2]
      };
      expect(
          SomeListMessage.fromJson(serialized),
          SomeListMessage((b) => b
            ..stringList = ['first', 'second']
            ..intList = [1, 2]));
    });

    test('serialize', () {
      final message = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3]);
      expect(message.toJson(), {
        'stringList': ['a', 'b'],
        'intList': [3]
      });
    });

    test('hashCode', () {
      final message = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      final messageSame = SomeListMessage((b) => b
        ..stringList = ['a', 'b']
        ..intList = [3, 4]);
      final messageDifferent = SomeListMessage((b) => b
        ..stringList = ['c', 'd']
        ..intList = [3, 4]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('nested message', () {
    test('serialize', () {
      final serialized = {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      };
      expect(
          OuterMessage.fromJson(serialized),
          OuterMessage((b) => b
            ..innerField = InnerMessage((b) => b..anotherField = 'foo')
            ..stringField = 'value'));
    });
    test('deserialize', () {
      final message = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      expect(message.toJson(), {
        'innerField': {'anotherField': 'foo'},
        'stringField': 'value'
      });
    });
    test('hashcode', () {
      final message = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      final messageSame = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'foo')
        ..stringField = 'value');
      final messageDifferent = OuterMessage((b) => b
        ..innerField = InnerMessage((b) => b..anotherField = 'different')
        ..stringField = 'value');
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
    test('handles omitted keys', () {
      expect(OuterMessage.fromJson({}), OuterMessage((b) {}));
    });
    test('handles keys explicitly set to null', () {
      expect(OuterMessage.fromJson({'innerField': null, 'stringField': null}),
          OuterMessage((b) {}));
    });
  });

  group('nested message in list', () {
    test('serialize', () {
      final serialized = {
        'innerField': [
          {'anotherField': 'foo'},
          {'anotherField': 'bar'}
        ],
      };
      expect(
          OuterMessageWithList.fromJson(serialized),
          OuterMessageWithList((b) => b
            ..innerField = [
              InnerMessageInList((b) => b..anotherField = 'foo'),
              InnerMessageInList((b) => b..anotherField = 'bar'),
            ]));
    });
    test('deserialize', () {
      final message = OuterMessageWithList((b) => b
        ..innerField = [
          InnerMessageInList((b) => b..anotherField = 'foo'),
          InnerMessageInList((b) => b..anotherField = 'bar')
        ]);
      expect(message.toJson(), {
        'innerField': [
          {'anotherField': 'foo'},
          {'anotherField': 'bar'}
        ]
      });
    });
    test('hashcode', () {
      final message = OuterMessageWithList((b) =>
          b..innerField = [InnerMessageInList((b) => b..anotherField = 'foo')]);
      final messageSame = OuterMessageWithList((b) =>
          b..innerField = [InnerMessageInList((b) => b..anotherField = 'foo')]);
      final messageDifferent = OuterMessageWithList((b) => b
        ..innerField = [
          InnerMessageInList((b) => b..anotherField = 'different')
        ]);
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });

  group('subclassed message', () {
    test('deserialize', () {
      final serialized = {'selectField': 'firstValue', 'firstField': 1};
      expect(ParentMessage.fromJson(serialized), isA<FirstChildMessage>());
      expect(ParentMessage.fromJson(serialized),
          FirstChildMessage((b) => b..firstField = 1));
    });

    test('serialize', () {
      final message = ThirdChildMessage();
      expect(message.toJson(), {'selectField': 'thirdValue'});
    });
  });

  group('map fields', () {
    test('deserialize', () {
      final serialized = {
        'intMap': {'a': 1},
        'messageMap': {
          'b': {
            'innerMessageMap': {'foo': 'bar'}
          }
        },
        'listMap': {
          'c': [1, 2]
        },
        'mapMap': {
          'd': {'e': 'f'}
        }
      };
      expect(
          SomeMapMessage.fromJson(serialized),
          SomeMapMessage((b) => b
            ..intMap = {'a': 1}
            ..messageMap = {
              'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
            }
            ..listMap = {
              'c': [1, 2]
            }
            ..mapMap = {
              'd': {'e': 'f'}
            }));
    });

    test('serialize', () {
      final message = SomeMapMessage((b) => b
        ..intMap = {'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      expect(message.toJson(), {
        'intMap': {'a': 1},
        'messageMap': {
          'b': {
            'innerMessageMap': {'foo': 'bar'}
          }
        },
        'listMap': {
          'c': [1, 2]
        },
        'mapMap': {
          'd': {'e': 'f'}
        }
      });
    });

    test('hashCode', () {
      final message = SomeMapMessage((b) => b
        ..intMap = {'a': 1, 'z': 2}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      final messageSame = SomeMapMessage((b) => b
        ..intMap = {'z': 2, 'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'bar'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      final messageDifferent = SomeMapMessage((b) => b
        ..intMap = {'a': 1}
        ..messageMap = {
          'b': AnotherMessage((b) => b..innerMessageMap = {'foo': 'different'})
        }
        ..listMap = {
          'c': [1, 2]
        }
        ..mapMap = {
          'd': {'e': 'f'}
        });
      expect(message.hashCode, messageSame.hashCode);
      expect(message.hashCode, isNot(messageDifferent.hashCode));
    });
  });
}
