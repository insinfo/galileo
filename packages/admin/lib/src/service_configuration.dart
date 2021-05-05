import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_validate/galileo_validate.dart';
import 'package:meta/meta.dart';
import 'field.dart';

class ServiceConfiguration {
  final String name;
  final String icon;
  final Service service;
  final Map<String, Field> fields;

  const ServiceConfiguration({@required this.name, @required this.service, @required this.fields, this.icon});
}
