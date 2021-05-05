Galileo, like many other Web server frameworks, features support for object-relational mapping,
or *ORM*. ORM tools allow for conversion from database results to Dart classes.

Galileo's ORM uses Dart's `build` system to generate query builder classes from your `Model` classes,
and takes advantage of Dart's strong typing to prevent errors at runtime.

Take, for example, the following class:

```dart
@orm
abstract class _Pokemon extends Model {
    String get nickName;

    int get level;

    int get experiencePoints;

    @belongsTo
    PokemonTrainer get trainer;

    @belongsTo
    PokemonSpecies get species;

    @belongsTo
    PokemonAttack get attack0;

    @belongsTo
    PokemonAttack get attack2;

    @belongsTo
    PokemonAttack get attack3;

    @belongsTo
    PokemonAttack get attack4;
}
```

`package:galileo_orm_generator` will generate code that lets
you do the following:

```dart
app.get('/trainer/int:id/first_moves', (req, res) async {
    var id = req.params['id'] as int;
    var executor = req.container.make<QueryExecutor>();
    var trainer = await findTrainer(id);
    var query = PokemonQuery()..where.trainerId.equals(id);
    var pokemon = await query.get(executor);
    return pokemon.map((p) => p.attack0.name).toList();
});
```

This section of the Galileo documentation consists mostly of
guides, rather than technical documentation.

For more in-depth documentation, see the actual
`galileo_orm` project on Github:

https://github.com/galileo-dart/orm
