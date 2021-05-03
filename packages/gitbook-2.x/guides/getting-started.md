# Getting Started
In this first guide, we will:
* Download the `angel_framework` package from Pub.
* Launch an `AngelHttp` server.
* Add some basic routes to an app.
* Add a 404 error handler.

The source code for this example can be found here:

https://github.com/angel-dart/examples-v2/tree/master/docs_examples/getting_started

# First Steps
This tutorial relies on the terminal/command-line, so if
are not well-versed in using such tools, you should
copy/paste the snippets found on this page.

If you have not yet installed the Dart SDK, then it is
required that you do so before continuing:

https://www.dartlang.org/tools/sdk#install

In addition, the `curl` tool will be used to send requests
to our server:

https://curl.haxx.se/download.html

Also, you will need to have the Dart SDK in your
`PATH` environment variable, so that the `dart` and `pub`
executables can be found from your command line:

https://www.java.com/en/download/help/path.xml

Finally, note that some steps will mention Unix-specific
programs, like `nano`. Windows users should instead use
Notepad. Alternative programs will be mentioned where
relevant.

# Project Setup
The first thing we'll need to do is create a new
directory (folder) for our project.

```bash
mkdir hello_angel
cd hello_angel
```

Next, we create a `pubspec.yaml` file, and enter the
following contents:

```yaml
name: hello_angel
dependencies:
    angel_framework: ^2.0.0
```

Now, just run `pub get`, which will install the
`angel_framework` library, and its dependencies:

```
Resolving dependencies... (3.3s)
+ angel_container 1.0.0
+ angel_framework 2.0.0
+ angel_http_exception 1.0.0+3
(... more output omitted)
Changed 33 dependencies!
```

# Launching an HTTP Server
Angel can speak different protocols, but more often than not,
we'll want it to speak HTTP.

Create a directory named `bin`, and a file within `bin` named
`main.dart`.

Your folder structure should now look like this:
```
hello_angel
    bin/
        main.dart
    pubspec.yaml
```

Add the following to `bin/main.dart`:

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';

main() async {
    var app = Angel();
    var http = AngelHttp(app);
    await http.startServer('localhost', 3000);
}
```

Next, in your terminal, run the command
`dart bin/main.dart`. Your server will now be running,
and will listen for input until you kill it by entering
`Control-C` (the `SIGINT` signal) into the terminal.

Open a new terminal window, and type the following:

```bash
curl localhost:3000 && echo
```

You'll just see a blank line, but the fact that you
*didn't see an error* means that the server is indeed
listening at port `3000`.

# Adding a Route
By adding *routes* to our server, we can respond to requests
sent to different URL's.

Let's a handler at the *root* of our server, and print
a simple `Hello, world!` message.

From this point, all new code needs to be added *before*
the call to `http.startServer` (or else it will never run).

Add this code to your program:

```dart
app.get('/', (req, res) => res.write('Hello, world!'));
```

`bin/main.dart` should now look like the following:

```dart
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';

main() async {
    var app = Angel();
    var http = AngelHttp(app);
    app.get('/', (req, res) => res.write('Hello, world!'));
    await http.startServer('localhost', 3000);
}

```

(Note that this is the last time the entire file will be
pasted, for the sake of brevity.)

Now, if you rerun `curl localhost:3000 && echo`, you'll
see the message `Hello, world!` printed to your terminal!

# Route Handlers
Let's break down the line we just added:

```dart
app.get('/', (req, res) => res.write('Hello, world!'));
```

It consists of the following components:
* A call to `app.get`
* A string, `'/'`,
* A closure, taking two parameters: `req` and `res`
* The call `res.write('Hello, world!')`, which is
also the return value of the aforementioned closure.

`Angel.get` is one of several methods (`addRoute`, `post`,
`patch`, `delete`, `head`, `get`) that can be used to
add routes that correspond to
[HTTP methods](https://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html)
to an `Angel` server instance.

Combined with the path, `'/'`, this signifies that whenever
a request is sent to the *root* of our server, which in
this case is the URL `http://localhost:3000`, the attached
closure should be invoked.

The path is important because it defines the conditions under
which code should run. For example, if we were to visit
`http://localhost:3000/foo`, we'd just see a blank line printed
again, because there is no route mounted corresponding to
the path `'/foo'`.

The two parameters, `req` and `res`, hold the types
`RequestContext` and `ResponseContext`, respectively.
We'll briefly cover these in the next section.

Finally, we call `res.write`, which, as you may have surmised,
prints a value to the outgoing HTTP response. That's how
we are able to print `Hello, world!`.

# Printing Headers
Just as their names suggest, the `RequestContext`
and `ResponseContext` classes are abstractions used to
read and write data on the Web.

By reading the property `req.headers`, we can access the
[HTTP headers](https://tools.ietf.org/html/rfc2616#section-4.2)
sent to us by the client:

```dart
app.get('/headers', (req, res) {
    req.headers.forEach((key, values) {
        res.write('$key=$values');
        res.writeln();
    });
});
```

Run the following:

```bash
curl -H 'X-Foo: bar' -H 'Accept-Language: en-US' \
http://localhost:3000/headers && echo
```

And you'll see output like the following:

```
user-agent=[curl/7.54.0]
accept=[*/*]
accept-language=[en-US]
x-foo=[bar]
host=[localhost:3000]
```

# Reading Request Bodies
Web applications very often have users send data upstream,
where it is then handled by the server.

Angel has built-in functionality for parsing bodies of three
MIME types:
* `application/json`
* `application/x-www-form-urlencoded`
* `multipart/form-data`

(You can also handle others, but that's beyond the scope
of this demo.)

So, as long as the user sends data in one of the above forms,
we can handle it in the same way.

Add the following route.
It will listen on the path `'/greet'` for a
`POST` request, and then attempt to parse the
incoming request body.

Afterwards, it reads the `name` value from the body,
and computes a greeting string.

```dart
app.post('/greet', (req, res) async {
    await req.parseBody();

    var name = req.bodyAsMap['name'] as String;

    if (name == null) {
        throw AngelHttpException.badRequest(message: 'Missing name.');
    } else {
        res.write('Hello, $name!');
    }
});
```

To visit this, enter the following `curl` command:

```bash
curl -X POST -d 'name=Bob' localhost:3000/greet && echo
```

You should see `Hello, Bob!` appear in your terminal.

# Adding an Error Handler
In the previous example, you might have noticed this
line:

```dart
throw AngelHttpException.badRequest(message: 'Missing name.');
```

Angel handles errors thrown while calling route handlers,
preventing your server from crashing. Ultimately,
all errors are wrapped in the `AngelHttpException` class, or
sent as-is if they are already instances of `AngelHttpException`.

By default, either an HTML page is printed, or a JSON message
is displayed (depending on the client's `Accept` header).
In many cases, however, you might want to do something else,
i.e. rendering an error page, or logging errors through a service
like Sentry.

To add your own logic, set the `errorHandler` of your
`Angel` instance. It is a function that accepts 3 parameters:
* `AngelHttpException`
* `RequestContext`
* `ResponseContext`

```dart
var oldErrorHandler = app.errorHandler;

app.errorHandler = (e, req, res) {
if (e.statusCode == 400) {
    res.write('Oops! You forgot to include your name.');
} else {
    return oldErrorHandler(e, req, res);
}
```

Note that we kept a reference to the previous error handler,
so that existing logic can be reused if the case we wrote
for is not handled.

To trigger a `400 Bad Request` and see our error handler in
action, run the following:

```bash
curl -H 'Content-Type: application/x-www-form-urlencoded' \
-X POST localhost:3000/greet && echo
```

You will now see `'Oops! You forgot to include your name.'`
printed to the console.

# Conclusion
Congratulations on creating your first Angel server!
Hopefully this is just one of many more to come.

The choice is now yours: either continue reading the
other guides posted on this site, or tinker around and
learn the ropes yourself.

You can find `angel_*` packages on the Pub site, and
read the documentation found in their
respective `README` files:

https://pub.dartlang.org/packages?q=dependency%3Aangel_framework

Don't forget that for discussion and support, you can either
file a Github issue, or join the Gitter chat:

https://gitter.im/angel_dart/discussion