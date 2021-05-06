library galileo_orm.generator.models.book;

import 'package:galileo_migration/galileo_migration.dart';
import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_orm/galileo_orm.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'book.g.dart';

@serializable
@orm
class _Book extends Model {
  @BelongsTo(joinType: JoinType.inner)
  _Author author;

  @BelongsTo(localKey: "partner_author_id", joinType: JoinType.inner)
  _Author partnerAuthor;

  String name;
}

@serializable
@orm
abstract class _Author extends Model {
  @Column(length: 255, indexType: IndexType.unique)
  @SerializableField(defaultValue: 'Isaque Neves')
  String get name;
}
