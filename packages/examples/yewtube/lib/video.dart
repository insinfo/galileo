import 'package:galileo_model/galileo_model.dart';
import 'package:galileo_serialize/galileo_serialize.dart';
part 'video.g.dart';

@serializable
abstract class _Video extends Model {
  String get title;

  String get description;

  String get filePath;

  String get mimeType;
}
