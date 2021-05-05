# Galileo CLI

The [Galileo CLI](https://github.com/galileo-dart/cli) is a friendly
command line tool enabling quick scaffolding of common project
constructs.

To install it:

```bash
$ pub global activate galileo_cli
```

You'll then be able to run:

```bash
$ galileo --help
```

The above will print documentation about each available command.


## Scaffolding
### New Projects
Bootstrapping a new Galileo project, complete, CORS, hot-reloading, and
more, is as easy as running:

```bash
$ galileo init <dirname>
```

You'll be ready to go after this!

### Project Files
Use `galileo make` to scaffold common Dart files:
*  `galileo make service` - Generate an in-memory, MongoDB, RethinkDB, file-based, or other [service](../services/service-basics.md).
* `galileo make test`
* `galileo make plugin`
* `galileo make model`
* `galileo make model --orm`
* `galileo make controller`

### Deployment helpers
* `sudo -E galileo deploy nginx -o /etc/sites-available/my_app.conf`
* `sudo -E galileo deploy systemd -o /etc/systemd/system/my_app.service`

## Renaming the Project
To rename your project, and fix all references, run:

```bash
$ galileo rename <new-name>
```
