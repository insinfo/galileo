# vagrant
Vagrantfile for quick deployment of Angel apps into Ubuntu 16.04 VM's.

There are three base boxes:
* `angel-dart`: Ubuntu 16.04 with `nginx` and `systemd` configuration.
* `angel-dart-mongodb`: Extends `angel-dart`; installs MongoDB.
* `angel-dart-postgresql`: Extends `angel-dart`; installs PostgreSQL; attempts to run `tool/migration.dart up`.