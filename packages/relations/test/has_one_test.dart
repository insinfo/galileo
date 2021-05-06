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

    // TODO: Missing afterAll method
    //  app.findService('authors').afterAll(
    //      relations.hasOne('books', as: 'book', foreignKey: 'authorId'));
  });

  test('index', () async {
    var authors = await app.findService('authors').index();
    print(authors);

    expect(authors, allOf(isList, isNotEmpty));

    for (Map author in authors) {
      expect(author.keys, contains('book'));

      Map book = author['book'];
      print('Author: $author');
      print('Book: $book');
      expect(book['authorId'], equals(author['id']));
    }
  });

  test('create', () async {
    var tolstoy = await app
        .findService('authors')
        .create(Author(name: 'Leo Tolstoy').toJson());

    print(tolstoy);
    expect(tolstoy.keys, contains('book'));
    expect(tolstoy['book'], isNull);
  });
}
