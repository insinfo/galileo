//import 'package:dart2_constant/convert.dart';
import 'dart:convert';

getValue(String value) {
  try {
    num numValue = num.parse(value);
    if (!numValue.isNaN)
      return numValue;
    else
      return value;
  } on FormatException {
    if (value.startsWith('[') && value.endsWith(']'))
      return jsonDecode(value);
    else if (value.startsWith('{') && value.endsWith('}'))
      return jsonDecode(value);
    else if (value.trim().toLowerCase() == 'null')
      return null;
    else
      return value;
  }
}
