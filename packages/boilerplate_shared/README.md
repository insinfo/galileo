# boilerplate_shared
Boilerplate for a project holding models, etc. shared across multiple Dart projects.

Example setup:

Run:

```bash
angel init
```

Structure:

```
foo/
    foo/
    foo_server/
    foo_mobile/
    foo_web/
```

Where:
* `foo/` is the "shared" project that contains things like model files or validators
* `foo_server/` is also created by `angel init`
* `foo_mobile/` is a Flutter project
* `foo_web/` is a Dart web project, perhaps created via `stagehand`.

In this case, the `boilerplate_shared` will create `foo/`.