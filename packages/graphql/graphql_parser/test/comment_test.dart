import 'package:galileo_graphql_parser/galileo_graphql_parser.dart';
import 'package:test/test.dart';

void main() {
  test('heeds comments', () {
    var tokens = scan('''
    # Hello
    {
    # Goodbye
    }
    # Bonjour
    ''');

    expect(tokens, hasLength(2));
  });
}
