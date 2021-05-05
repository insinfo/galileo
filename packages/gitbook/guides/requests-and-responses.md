# Requests-and-Responses

* [Requests and Responses](requests-and-responses.md#requests-and-responses)
  * [Return Values](requests-and-responses.md#return-values)
  * [Other Parameters](requests-and-responses.md#other-parameters)
  * [Queries, Files and Bodies](requests-and-responses.md#queries-files-and-bodies)
* [Next Up...](requests-and-responses.md#next-up)

## Requests and Responses

Galileo is inspired by Express, and such, request handlers in general resemble those from Express. Request handlers can return any Dart object \(see [how they are handled](requests-and-responses.md#return-values)\). Basic request handlers accept two parameters:

* [`RequestContext`](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/RequestContext-class.html) - Contains vital information about the client requesting a resource, such as request method, request body, IP address, etc. The request object can also be used to pass information from one handler to the next. 
* [`ResponseContext`](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/ResponseContext-class.html) - Allows you to send headers, write data, and more, to be sent to the client. To prevent a response from being modified by future handlers, call `res.end()` to prevent further writing.

### Return Values

Request handlers can return any Dart value. Return values are handled as follows:

* If you return a `bool`: Request handling will end prematurely if you return `false`, but it will continue if you return `true`.
* If you return `null`: Request handling will continue, unless you closed the response object by calling [`res.close()`](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/ResponseContext/close.html). Some response methods, such as [`res.redirect()`](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/ResponseContext/redirect.html) or [`res.serialize()`](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/ResponseContext/serialize.html) automatically close the response.
* A `RequestHandler`: the returned handler will be executed.
* A `Stream`: `toList` will be called, and then returned.
* A `Future`: it will be awaited, and then returned.
* Anything else: Whatever other Dart value you return will be serialized as a response. The default method is to encode responses as JSON, using `json.encode`. However, you can change a response's serialization method by setting `res.serializer = foo;`. If you want to assign the same serializer to all responses, globally set [`serializer`](https://pub.dartlang.org/documentation/galileo_framework/latest/galileo_framework/Galileo/serializer.html) on your Galileo instance. If you are only returning JSON-compatible Dart objects, like Maps or Lists, you might consider injecting `JSON.encode` as a serializer, to improve runtime performance (this is the default in `2.0`).

### Other Parameters

Request handlers can take other parameters, instead of just a `RequestContext` and `ResponseContext`.
Consult the [dependency injection documentation](dependency-injection.md#in-routes-and-controllers).

### Queries, Files and Bodies

You can access a mutable `Map` based on the URI query parameters by calling `RequestContext.queryParameters`.

Consult the [body parsing documentation](body-parsing.md) to understand how to handle user input.

If you [write your own plugin](../advanced/writing-a-plugin.md), be sure to use the `lazy` alternatives.

For more information, see the API docs:

[RequestContext](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/RequestContext-class.html)

[ResponseContext](https://www.dartdocs.org/documentation/galileo_framework/latest/galileo_framework/ResponseContext-class.html)

## Next Up...

Now, let's learn about Galileo's [flexible router](basic-routing.md). 

