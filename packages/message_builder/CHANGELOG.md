## 3.0.1

- update dependencies

## 0.1.7-dev

## 0.1.6

- Use a chain of `&&` in `operator ==` methods. This fixes a problem where some
  conditionals which were too long to fit on one line would violate
  `curly_braces_in_flow_control_structures` lint.

## 0.1.5

- Generate code that has no lints from `package:pedantic` at version `1.9.0`.
- Generate code that follow `prefer_final_locals` lint

## 0.1.4

- Generate code without implicit casts.

## 0.1.3+6

- Allow `build_config` version `0.4.x`.

## 0.1.3+5

- Allow `build` versions `<2.0.0`.

## 0.1.3+4

- Use the 2.0 stable SDK.

## 0.1.3+3

- Cast to `Iterable` before calling `map` when parsing from json to get a
  correct reified list type.
- Switch to `Map.map` instead of `new Map.fromIterable`.
- Cast primitive typed `List` and `Map` instances to a corrected reified type.

## 0.1.3+2

- Allow `package:build_config` version `0.3.x`.

## 0.1.3+1

- Allow `package:build` version `0.12.x`.

## 0.1.3

- Upgrade to `code_builder` version 3.0
- Add default for `generate_for` to avoid applying to `pubspec.yaml` by default.

## 0.1.2

- Handle keys explicitly set to `null` as if they were missing.

## 0.1.1

- Add a `build.yaml` so this builder can be used with `build_runner` v0.7.0

## 0.1.0

- Initial version. Extracted from
  [dart_language_server](https://github.com/natebosch/dart_language_server)
- Refactor to use `code_builder`.
- Add support for Map type fields.
