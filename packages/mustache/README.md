# mustache
[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/galileo_dart/discussion)
[![version](https://img.shields.io/pub/v/galileo_mustache.svg)](https://pub.dartlang.org/packages/galileo_mustache)
[![build status](https://travis-ci.org/galileo-dart/mustache.svg?branch=master)](https://travis-ci.org/galileo-dart/mustache)

Mustache (Handlebars) view generator for the [Galileo](https://github.com/galileo-dart/galileo)
web server framework.

Thanks so much @c4wrd for his help with bringing this project to life!

# Installation
In `pubspec.yaml`:

```yaml
dependencies:
    galileo_mustache: ^2.0.0
```

# Usage
```dart
const FileSystem fs = const LocalFileSystem();

configureServer(Galileo app) async {
  // Run the plug-in
  await app.configure(mustache(fs.directory('views')));
  
  // Render `hello.mustache`
  await res.render('hello', {'name': 'world'});
}
```

# Options
- **partialsPath**: A path within the viewsDirectory to search for partials in.
    Default is `./partials`.
- **fileExtension**: The file extension to search for. Default is `.mustache`.
