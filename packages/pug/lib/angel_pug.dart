import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:jaded/jaded.dart' as jade;

/// Configures your application to render Pug (nee Jade) views out of a given directory.
///
/// The `pug` function accepts an optional [extensions] parameter,
/// which defaults to `['.pug', '.jade']`. These extensions will be suffixed to template names
/// when calling `res.render` (i.e. `res.render('foo')` searches for `['foo.pug', 'foo.jade']`)
/// to find the corresponding view file.

/// If you set it to an empty iterable, then extensions
/// will not be added. This is a rare case, and only is necessary if your template files have no extensions.
AngelConfigurer pug(Directory source, {Iterable<String> extensions}) {
  List<String> ext;

  if (!(extensions?.isEmpty == true))
    ext = extensions?.isNotEmpty == true
        ? extensions.toList()
        : ['.pug', '.jade'];

  return (Angel app) async {
    app.viewGenerator = (String name, [Map locals]) async {
      // Resolve filenames
      List<String> filenames = [name];

      if (ext?.isNotEmpty == true) {
        for (var extension in ext) {
          filenames.add('$name$extension');
        }
      }

      for (var filename in filenames) {
        var file = new File.fromUri(source.uri.resolve(filename));

        if (await file.exists()) {
          var contents = await file.readAsString();
          var render = jade.compile(contents);
          return await render(locals ?? {});
        }
      }

      throw new FileSystemException(
          'No Pug view "$name" was found in directory "${source.absolute.path}".',
          name);
    };
  };
}
