import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_relations/galileo_relations.dart' as relations;
import 'package:galileo_seeder/galileo_seeder.dart';
import 'package:test/test.dart';
import 'common.dart';

main() {
  Galileo app;

  setUp(() async {
    app = Galileo()..use('/authors', MapService())..use('/books', MapService());

    await app.configure(seed(
        'authors',
        SeederConfiguration<Map>(
            count: 10,
            template: {'name': (Faker faker) => faker.person.name()},
            callback: (Map author, seed) {
              return seed(
                  'books',
                  SeederConfiguration(delete: false, count: 10, template: {
                    'authorId': author['id'],
                    'title': (Faker faker) =>
                        'I love to eat ${faker.food.dish()}'
                  }));
            })));

    // TODO: Missing method afterAll
    //app.findService ('books').afterAll(relations.belongsTo('authors'));
  });

  test('index', () async {
    var books = await app.findService('books').index();
    print(books);

    expect(books, allOf(isList, isNotEmpty));

    for (Map book in books) {
      expect(book.keys, contains('author'));

      Map author = book['author'];
      expect(author['id'], equals(book['authorId']));
    }
  });

  test('create', () async {
    var warAndPeace = await app
        .findService('books')
        .create(Book(title: 'War and Peace').toJson());

    print(warAndPeace);
    expect(warAndPeace.keys, contains('author'));
    expect(warAndPeace['author'], isNull);
  });
}
