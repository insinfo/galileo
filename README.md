**A polished, production-ready backend framework in Dart.**

-----
## About
Galileo is a full-stack Web framework in Dart. It aims to
streamline development by providing many common features
out-of-the-box in a consistent manner.

With features like the following, Galileo is the all-in-one framework you should choose to build your next project:
* GraphQL Support
* PostgreSQL ORM
* Dependency Injection
* Static File Handling
* And much more...

See all the packages in the `packages/` directory.


## Installation & Setup

Once you have [Dart](https://www.dartlang.org/) installed, bootstrapping a project is as simple as running a few shell commands:

Install the [Galileo CLI](https://github.com/insinfo/cli):

```bash
pub global activate --source git https://github.com/insinfo/cli.git
```

Bootstrap a project:

```bash
Galileo init hello
```

You can even have your server run and be *hot-reloaded* on file changes:

```bash
dart --observe bin/dev.dart
```

(For CLI development only)Install Galileo CLI

```bash
pub global activate --source path ./packages/cli
```

Next, check out the [detailed documentation](https://docs.Galileo-dart.dev/v/2.x) to learn to flesh out your project.

## Examples and Documentation
Visit the [documentation](https://docs.Galileo-dart.dev/v/2.x)
for dozens of guides and resources, including video tutorials,
to get up and running as quickly as possible with Galileo.

Examples and complete projects can be found
[here](https://github.com/Galileo-dart/examples-v2).


You can also view the [API Documentation](http://www.dartdocs.org/documentation/Galileo_framework/latest).

There is also an [Awesome Galileo :fire:](https://github.com/Galileo-dart/awesome-Galileo) list.

## Contributing
Interested in contributing to Galileo? Start by reading the contribution guide [here](CONTRIBUTING.md).
