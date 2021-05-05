Based on [this discussion](https://github.com/galileo-dart/galileo/issues/49).

Based on the chgalileoog, up to `1.1.0`: https://pub.dartlang.org/packages/galileo_framework/versions/1.1.1#-chgalileoog-tab-

# Main Points
* `galileo_diagnostics` is deprecated - instead just pass a `Logger` and set it as `app.logger`.
* Removed `GalileoFatalError`, and subsequently `fatalErrorStream`.
  * Errors are automatically create `500`. Set `app.logger` to see output.
  * `galileo_errors` is no longer useful.
* Removed all `@deprecated` members.
* Removed @Hooked, beforeProcessed, and afterProcessed.
* Made injections in RequestContext private.
* Renamed properties in GalileoBase to configuration.
* Added support for pattern matching and other injections via `@Parameter()`
* Officially deprecated properties in Galileo.
* Fixed a bug where cached routes would not heed the request method. #173
* Reworked error handling logic; now, errors will not automatically default to sending JSON.
* Removed the onController stream from Galileo.
* Controllers now longer use call, which has now been renamed to configureServer.

## Notes
Aside from these points, there are several things to note.

Migration in itself will be pretty easy to achieve. Plugins and services haven't really changed, it's just the HTTP server itself.

# What should I use instead of `X`?
In 1.1.0, the following were completely removed:
    * `Galileo.after`,
    * `Galileo.before`
    * `Galileo.justBeforeStart`
    * `Galileo.justBeforeStop`
    * `Galileo.fatalErrorStream`

 * There is no replacement for `before`/`after`. This way, it is easier to keep track of the order request handlers run. responseFinalizers are still in place.

 * `justBeforeStart`, `justBeforeStop` => `startupHooks`, `shutdownHooks`
 * `fatalErrorStream` is no longer necessary; you can just set `app.errorHandler`. Fatal errors will be wrapped in a 500 response.

# How should I define global middleware?
`app.use((req, res) => ...)`

Much cleaner in `1.1.0`. 😄
