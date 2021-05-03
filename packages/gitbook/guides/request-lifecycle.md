# Request-Lifecycle

Requests in the Angel framework go through a relatively complex lifecycle, and to truly master the framework, one must understand that lifecycle.

1. `startServer` is called.
2. Each `HttpRequest` is sent through `handleRequest`.
3. `handleRequest` converts the `HttpRequest` to a `RequestContext`, and converts its `HttpResponse` into a
   `ResponseContext`.

4. `angel_route` is used to match the request path to a list of request handlers.
5. Each handler is executed.
6. If the response is using streaming, and not buffering content, skip to step 8 (default). 
7. All `responseFinalizers` are run.
8. If `res.isDetached == false`, all headers, the status code and the response buffer are sent through the actual `HttpResponse`.
9. The `HttpResponse` is closed.

If at any point an error occurs, Angel will catch it. See the [error handling](error-handling.md) docs for more.

