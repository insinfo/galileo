# 3.0.0

- update dependencies

# 2.2.0
* Allow including one configuration within another.
* Badly-formatted `.env` files will no longer issue a warning,
but instead throw an exception.

# 2.1.0
* Add `loadStandaloneConfiguration`.

# 2.0.0
* Use Galileo 2.

# 1.2.0-rc.0
* Removed the `Configuration` class.
* Removed the `ConfigurationTransformer` class.
* Use `Map` casting to prevent runtime cast errors.

# 1.1.0 (Retroactive chgalileoog)
* Use `package:file`.

# 1.0.5
* Now using `package:merge_map` to merge configurations. Resolves
[#5](https://github.com/galileo-dart/configuration/issues/5).
* You can now specify a custom `envPath`.
