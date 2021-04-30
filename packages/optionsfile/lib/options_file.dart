library options_file;

import 'dart:io';

/**
 * [OptionsFile] reads options from a file. The options must be stored in name=value pairs, one pair per line. E.g.:
 * 
 *     name=James
 *     age=9
 *     height=256
 *     
 * Spaces around the key and value are trimmed. Any line which starts with a hash (#) is ignored.
 * Any line which does not contain an equals sign is ignored.
 */
class OptionsFile {
  late Map<String, String> _map;

  /**
   * Load options from the file called [filename], with defaults in the [defaults] file if specified.
   *
   * Throws [FileIOException] if either file specified does not exist.
   */
  OptionsFile(String filename, [String? defaults]) {
    _map = <String, String>{};
    if (defaults != null) {
      var defaultOptions = new File(defaults);
      _readOptions(defaultOptions);
    }
    var options = new File(filename);
    _readOptions(options);
  }

  void _readOptions(File options) {
    if (options.existsSync()) {
      var lines = options.readAsLinesSync();
      for (var line in lines) {
        if (!line.startsWith('#')) {
          var i = line.indexOf('=');
          if (i > -1) {
            var name = line.substring(0, i).trim();
            var value = line.substring(i + 1).trim();
            _map[name] = value;
          }
        }
      }
    } else {
      throw new FileSystemException("File not found", options.path);
    }
  }

  /**
   * Get a string value from the options file. If the value is not found in the file,
   * null is returned.
   */
  String? operator [](String key) => _map[key];

  /**
   * Get an integer value from the options file. If the given [key] is not found in the
   * options file or the default options file, the [defaultValue] is returned if specified,
   * or null if it is not specified.
   *
   * Throws a [FormatException] if the value is not a valid integer literal.
   */
  int? getInt(String key, [int? defaultValue]) {
    final value = _map[key];
    if (value == null) {
      return defaultValue;
    }
    return int.parse(value);
  }

  /**
   * Get a string value from the options file. If the given [key] is not found in the 
   * options file or the default options file, the [defaultValue] is returned if specified, 
   * or null if it is not specified.
   */
  String? getString(String key, [String? defaultValue]) {
    var value = _map[key];
    if (value != null) {
      return value;
    }
    return defaultValue;
  }
}
