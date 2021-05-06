options_file
===========

Dart library for reading options files

**OptionsFile** reads options from a file. The options must be stored in *name=value* pairs, one pair per line. E.g.:

    # stuff
    name=James
    age=9
    height=256
    
Spaces around the key and value are trimmed. Any line which starts with a hash (#) is ignored.
Any line which does not contain an equals sign is ignored.


Usage
=====
    OptionsFile options = new OptionsFile('example/local.options', 'example/default.options');
  
    String user = options.getString('user', 'bob');
    int port = options.getInt('port', 1234);

For further information on using optionsfile, see the dartdoc in options.dart, and the example files.
