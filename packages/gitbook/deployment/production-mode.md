# Production-Mode

Angel can optionally run in "production mode," where several optimizations are applied to the base server, such as running reflective dependency injection before server startup, and flattening the server's route tree.

Production mode is considered a global setting.

`angel_configuration` will load a `config/production.yaml` file to read configuration.

To run your application in production mode, set `ANGEL_ENV` in your environment to `production`. If you are writing a plug-in with production mode-specific code, query its value as follows:

```dart
if (app.isProduction) {
  // Do some production-only stuff...
}
```

 