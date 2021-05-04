import 'package:galileo_serialize/galileo_serialize.dart';
part 'subclass.g.dart';

@serializable
class _Animal {
  @notNull
  String genus;
  @notNull
  String species;
}

@serializable
class _Bird extends _Animal {
  @DefaultsTo(false)
  bool isSparrow;
}

var saxaulSparrow = Bird(
  genus: 'Passer',
  species: 'ammodendri',
  isSparrow: true,
);
