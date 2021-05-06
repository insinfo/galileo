/// Configuration for this Galileo instance.
library galileo.src.config;

import 'package:galileo_configuration/galileo_configuration.dart';
import 'package:galileo_framework/galileo_framework.dart';
import 'package:galileo_jael/galileo_jael.dart';
import 'package:file/file.dart';
import 'plugins/plugins.dart' as plugins;

/// This is a perfect place to include configuration and load plug-ins.
GalileoConfigurer configureServer(FileSystem fileSystem) {
  return (Galileo app) async {
    // Load configuration from the `config/` directory.
    //
    // See: https://github.com/galileo-dart/configuration
    await app.configure(configuration(fileSystem));

    // Configure our application to render Jael templates from the `views/` directory.
    //
    // See: https://github.com/galileo-dart/jael
    await app.configure(jael(fileSystem.directory('views')));

    // Apply another plug-ins, i.e. ones that *you* have written.
    //
    // Typically, the plugins in `lib/src/config/plugins/plugins.dart` are plug-ins
    // that add functionality specific to your application.
    //
    // If you write a plug-in that you plan to use again, or are
    // using one created by the community, include it in
    // `lib/src/config/config.dart`.
    await plugins.configureServer(app);
  };
}
