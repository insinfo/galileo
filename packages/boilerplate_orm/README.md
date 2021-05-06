# boilerplate_orm
[![The Galileo Framework](https://galileo-dart.github.io/images/logo.png)](https://galileo-dart.github.io)

A starting point for
[Galileo](https://galileo-dart.github.io) applications that use
Galileo's ORM.

[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/galileo_dart/discussion)
[![Pub](https://img.shields.io/pub/v/galileo_common.svg)](https://pub.dartlang.org/packages/galileo_common)

**Fill out the [v1.0.0 survey](https://docs.google.com/forms/d/e/1FAIpQLSfEgBNsOoi_nYZMmg2IAGyMv1nNaa6B3kUk3QdNJU5987ucVA/viewform?usp=sf_link) now!!!**

[Wiki (in-depth documentation)](https://github.com/galileo-dart/galileo/wiki)

[API Documentation](http://www.dartdocs.org/documentation/galileo_common/latest)

[Roadmap](https://github.com/galileo-dart/roadmap/blob/master/ROADMAP.md)

[File an Issue](https://github.com/galileo-dart/roadmap/issues)

[Awesome Galileo :fire:](https://github.com/galileo-dart/awesome-galileo)

To run in development, with hot-reload support:
```bash
dart bin/server.dart
```

To run in production, with hot-reload turned off:
```bash
ANGEL_ENV=production dart bin/server.dart
```

## Migrations
This boilerplate includes support for Galileo's ORM, with a migration system
directly inspired by Laravel's.

Run `dart tool/migrate.dart --help` for help.
