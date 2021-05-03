# boilerplate_orm
[![The Angel Framework](https://angel-dart.github.io/images/logo.png)](https://angel-dart.github.io)

A starting point for
[Angel](https://angel-dart.github.io) applications that use
Angel's ORM.

[![Gitter](https://img.shields.io/gitter/room/nwjs/nw.js.svg)](https://gitter.im/angel_dart/discussion)
[![Pub](https://img.shields.io/pub/v/angel_common.svg)](https://pub.dartlang.org/packages/angel_common)

**Fill out the [v1.0.0 survey](https://docs.google.com/forms/d/e/1FAIpQLSfEgBNsOoi_nYZMmg2IAGyMv1nNaa6B3kUk3QdNJU5987ucVA/viewform?usp=sf_link) now!!!**

[Wiki (in-depth documentation)](https://github.com/angel-dart/angel/wiki)

[API Documentation](http://www.dartdocs.org/documentation/angel_common/latest)

[Roadmap](https://github.com/angel-dart/roadmap/blob/master/ROADMAP.md)

[File an Issue](https://github.com/angel-dart/roadmap/issues)

[Awesome Angel :fire:](https://github.com/angel-dart/awesome-angel)

To run in development, with hot-reload support:
```bash
dart bin/server.dart
```

To run in production, with hot-reload turned off:
```bash
ANGEL_ENV=production dart bin/server.dart
```

## Migrations
This boilerplate includes support for Angel's ORM, with a migration system
directly inspired by Laravel's.

Run `dart tool/migrate.dart --help` for help.