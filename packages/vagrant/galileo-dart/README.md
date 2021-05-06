# vagrant
Vagrantfile for quick deployment of Galileo apps into Ubuntu 16.04 VM's.

Find the `galileo-dart` box on the Vagrant site:
https://app.vagrantup.com/thosakwe/boxes/galileo-dart

## Usage
From the command line:

```bash
vagrant init thosakwe/galileo-dart
vagrant up
```

Or, within an existing `Vagrantfile`:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "thosakwe/galileo-dart"
end
```

## Features
This box includes:
* Dart
* `nginx` - reverse proxies your app, also serves static files
* `systemd` configuration; starts your app as a daemon

Note that no database is included; the choice is yours.
See the `galileo-dart-mongodb` and `galileo-dart-postgresql` boxes.
