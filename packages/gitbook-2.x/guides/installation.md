# Installation

* [Getting Started](installation.md#getting-started)
  * [Installation](installation.md#installation)
    * [Prerequisites](installation.md#prequisites)
* [Next Up...](installation.md#next-up)

## Getting Started

Let's get it started, ha!

### Installation

#### Prerequisites

* Firstly, ensure you have the [Dart SDK](https://www.dartlang.org/downloads/) installed.

Now, install the [Angel CLI](cli.md). The CLI includes several code generators and commands that will help you expedite your development cycle.

```bash
$ pub global activate angel_cli
```

Now, let's create a sample project, called `hello`.

Run:

```bash
$ angel init hello
```

This will create a folder called `hello`, and copy the [Angel boilerplate](https://github.com/angel-dart/angel) into it. If you wanted to initialize a project within the current directory, instead of making new one, you could have run:

```bash
$ angel init
```

Follow the instructions given. There are different types of boilerplates, but all of the server
templates will generate very similarly-structured projects.

It's easy to run our server. Just type the following:

```bash
# Use the `--observe` flag to enable hot reloading in Angel.
dart --observe bin/server.dart
```

And there you have it - you've created an Angel application!

## Next Up...

Continue reading to learn about [requests and responses](requests-and-responses.md).

