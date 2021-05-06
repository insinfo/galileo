# vagrant
Vagrantfile for quick deployment of Galileo apps into Ubuntu 16.04 VM's.

There are three base boxes:
* `galileo-dart`: Ubuntu 16.04 with `nginx` and `systemd` configuration.
* `galileo-dart-mongodb`: Extends `galileo-dart`; installs MongoDB.
* `galileo-dart-postgresql`: Extends `galileo-dart`; installs PostgreSQL; attempts to run `tool/migration.dart up`.
