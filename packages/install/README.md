# ARCHIVED
Most of the boilerplate that this repo intended to resolve has been solved, because `package:build_config` allows users to use `build.yaml` files to simplify builder configuration. Adding things like the ORM and model serialization is really now as simple as installing dependencies.

# install
The repository for `angel install` add-ons.

The goal of the add-on system is to eliminate virtually all boilerplate from the development cycle.
Feel free to submit a PR; the more add-ons, the better.

# Creating an Add-on
Each add-on should:
* Include adequate documentation, i.e. explain what it generates.
* Accomplish **one** thing.
* Be modular. Ideally, an add-on is implemented as an Angel plug-in, or some other function (i.e. a request handler).
* Be formatted cleanly, using `dartfmt`.
* Not conflict with any other add-ons. Users **must** be able to install your add-on without it breaking their project.
* Generate IntelliJ run configurations, if need be.

Your add-on **must** have a `pubspec.yaml` with a `name`, `version`, and `description`.
`dependencies` and `dev_dependencies` will be installed if present.

Any files to be copied into the project directory must be placed in a directory called `files/`.

Add-ons installation can also be interactive, and prompt the user for input `values`. To achieve this, create an `angel_cli.yaml` file:

## Example `angel_cli.yaml`

```yaml
templates:
        - hello.txt
        - foo/bar.txt
values:
        name:
                type: prompt
        mackle:
                type: choice
                description: Macklemore
                choices:
                        - Rap
                        - Artist
                        - LOL
        artist:
                type: prompt
                description: Your favorite artist
                default: Michael Jackson
```

`templates`, if present, must be an array of file paths or globs corresponding to files in the `files/` directory that should be rendered with Mustache.

`values` explicitly declares which keys are necessary to produce a working copy of the add-on. They can take the form of a `prompt`, or a `choice` (in which case `choices` is also required). You can only define an optional `default` value for a `prompt` key, but both kinds of keys can have a `description`.

The above would prompt:

```
[1] Rap
[2] Artist
[3] LOL
Macklemore:
name: (Prompt here)
```

All templates will have access to these `values`, as well as the following:
* `pubspec`: The contents of the `pubspec.yaml` of the user's project.
* `project_name`: The name of the user's project.
