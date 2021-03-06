# 2.0.6
* Support `--observe=*`, `--enable-vm-service=*` (`startsWith`, instead of `==`).

# 3.0.0
- update dependencies

# 2.0.5
* Use `dart:developer` to find the Observatory URI.
* Use the app's logger when necessary.
* Apply `package:pedantic`.

# 2.0.4
* Forcibly close app loggers on shutdown.

# 2.0.3
* Fixed up manual restart.
* Remove stutter on hotkey press.

# 2.0.2
* Fixed for compatibility with `package:Galileo_websocket@^2.0.0-alpha.5`.

# 2.0.1
* Add import of `package:Galileo_framework/http.dart`
  * https://github.com/Galileo-dart/hot/pull/7

# 2.0.0
* Update for Dart 2 + Galileo 2.

# 1.1.1+1
* Fix a bug that threw when `--observe` was not present.

# 1.1.1
* Disable the observatory from pausing the isolate
on exceptions, because Galileo already handles
all exceptions by itself.
