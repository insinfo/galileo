As one can imagine, a SQL ORM cannot be used with a NoSQL database.
However, this is usually not a problem, because the ideal use cases for NoSQL databases
typically do not require the functionality present in an ORM (namely, relation support).

With a NoSQL databases, you can use the `Service` API (you likely already are!),
and use `Service.map` to deal with Dart data only, rather than messing around with
`Map`s, and risking typos and refactoring challenges.

If you are using `package:angel_serialize`, this is pretty easy:

```dart
abstract class _Greeting extends Model {
    String get text;

    double get attachedMoney;
}

var service = MongoService(...);
var mappedService = service.map(GreetingSerializer.fromMap, GreetingSerializer.toMap);

// Now you can get Greeting instances.
var greeting = await mappedService.read(id);
print([greeting.text, greeting.attachedMoney]);
```