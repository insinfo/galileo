# galileo_seeder

[![version 1.0.](https://img.shields.io/pub/v/galileo_seeder.svg)](https://pub.dartlang.org/packages/galileo_seeder)
[![build status](https://travis-ci.org/galileo-dart/seeder.svg?branch=master)](https://travis-ci.org/galileo-dart/seeder)

Straightforward data seeder for Galileo services.
This is an almost exact port of [feathers-seeder](https://github.com/thosakwe/feathers-seeder),
so its documentation should almost exactly match up here.
Fortunately, I was also the one who made `feathers-seeder`, so if you ever need assistance,
file an issue. 

# Example
```dart
var app = new Galileo()..use('/todos', new TodoService());

await app.configure(seed(
    'todos',
    new SeederConfiguration<Todo>(delete: false, count: 10, template: {
        'text': (Faker faker) => 'Clean your room, ${faker.person.name()}!',
        'completed': false
    })));
```

**NOTE**: Don't *await* seeding at application startup; that's too slow.
Instead, run it asynchronously.
