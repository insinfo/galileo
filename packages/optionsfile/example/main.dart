import 'package:options_file/options_file.dart';

void main() {
  OptionsFile options =
      new OptionsFile('example/local.options', 'example/default.options');

  // these values are read from default.options, as they aren't in local.options
  String? user = options.getString('user', 'bob');
  String? type = options.getString('type', 'advanced');

  // these values are read from local.options
  int? port = options.getInt('port', 1234);
  String? host = options.getString('host', 'www.dartlang.org');

  // this value isn't in either file, so the default here is used
  String? parity = options.getString('parity', 'even');

  print("user=$user");
  print("type=$type");
  print("port=$port");
  print("host=$host");
  print("parity=$parity");
}
