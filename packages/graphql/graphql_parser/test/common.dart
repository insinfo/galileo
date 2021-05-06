import 'package:galileo_graphql_parser/galileo_graphql_parser.dart';

Parser parse(String text) => Parser(scan(text));
