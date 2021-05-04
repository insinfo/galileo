import 'package:inflection3/src/past.dart';

/// returns true if this word is in the past tense
bool isPastTense(String word) {
  return word.toLowerCase().trim() == PAST.convert(word).toLowerCase().trim();
}
