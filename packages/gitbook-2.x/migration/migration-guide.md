Based on [this discussion](https://github.com/angel-dart/angel/issues/49).

Based on the changelog, up to `1.1.0`: https://pub.dartlang.org/packages/angel_framework/versions/1.1.1#-changelog-tab-

# Main Points
* `angel_diagnostics` is deprecated - instead just pass a `Logger` and set it as `app.logger`.
* Removed `AngelFatalError`, and subsequently `fatalErrorStream`.
  * Errors are automatically create `500`. Set `app.logger` to see output.
  * `angel_errors` is no longer useful.
* Removed all `@deprecated` members.
* Removed @Hooked, beforeProcessed, and afterProcessed.
* Made injections in RequestContext private.
* Renamed properties in AngelBase to configuration.
* Added support for pattern matching and other injections via `@Parameter()`
* Officially deprecated properties in Angel.
* Fixed a bug where cached routes would not heed the request method. #173
* Reworked error handling logic; now, errors will not automatically default to sending JSON.
* Removed the onController stream from Angel.
* Controllers now longer use call, which has now been renamed to configureServer.

## Notes
Aside from these points, there are several things to note.

Migration in itself will be pretty easy to achieve. Plugins and services haven't really changed, it's just the HTTP server itself.

# What should I use instead of `X`?
In 1.1.0, the following were completely removed:
    * `Angel.after`,
    * `Angel.before`
    * `Angel.justBeforeStart`
    * `Angel.justBeforeStop`
    * `Angel.fatalErrorStream`

 * There is no replacement for `before`/`after`. This way, it is easier to keep track of the order request handlers run. responseFinalizers are still in place.

 * `justBeforeStart`, `justBeforeStop` => `startupHooks`, `shutdownHooks`
 * `fatalErrorStream` is no longer necessary; you can just set `app.errorHandler`. Fatal errors will be wrapped in a 500 response.

# How should I define global middleware?
`app.use((req, res) => ...)`

Much cleaner in `1.1.0`. 😄