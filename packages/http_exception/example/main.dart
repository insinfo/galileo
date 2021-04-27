import 'package:galileo_http_exception/galileo_http_exception.dart';

void main() => throw GalileoHttpException.notFound(message: "Can't find that page!");
