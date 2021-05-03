# Angel CLI

The [Angel CLI](https://github.com/angel-dart/cli) is a friendly
command line tool enabling quick scaffolding of common project
constructs.

To install it:

```bash
$ pub global activate angel_cli
```

You'll then be able to run:

```bash
$ angel --help
```

The above will print documentation about each available command.


## Scaffolding
### New Projects
Bootstrapping a new Angel project, complete, CORS, hot-reloading, and
more, is as easy as running:

```bash
$ angel init <dirname>
```

You'll be ready to go after this!

### Project Files
Use `angel make` to scaffold common Dart files:
*  `angel make service` - Generate an in-memory, MongoDB, RethinkDB, file-based, or other [service](../services/service-basics.md).
* `angel make test`
* `angel make plugin`
* `angel make model`
* `angel make model --orm`
* `angel make controller`

### Deployment helpers
* `sudo -E angel deploy nginx -o /etc/sites-available/my_app.conf`
* `sudo -E angel deploy systemd -o /etc/systemd/system/my_app.service`

## Renaming the Project
To rename your project, and fix all references, run:

```bash
$ angel rename <new-name>
```