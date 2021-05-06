# deprecated

# task
[![Pub](https://img.shields.io/pub/v/galileo_task.svg)](https://pub.dartlang.org/packages/galileo_task)
[![build status](https://travis-ci.org/galileo-dart/task.svg)](https://travis-ci.org/galileo-dart/task)

Support for running and scheduling asynchronous tasks within Galileo.
Parameters can be injected into scheduled tasks with the same
[dependency injection](https://github.com/galileo-dart/galileo/wiki/Dependency-Injection)
system used by Galileo.

* [Installation](#installation)
* [Usage](#usage)
  * [Multithreading](#multithreading)

# Installation
In your `pubspec.yaml` file:

```yaml
  dependencies:
    galileo_framework: ^1.0.0
    galileo_task: ^1.0.0
```

# Usage
```dart
main() async {
  var app = await createServer();
  var scheduler = new GalileoTaskScheduler(app);

  // Run a one-off task, with an optional delay.
  scheduler.once((Todo singleton) {
    print('3 seconds later, we found our Todo singleton: "${singleton.text}"');
  }, new Duration(seconds: 3));

  Task foo;
  int i = 0;

  // Periodically run functionality
  foo = scheduler.seconds(1, () {
    print('Printing ${++i} time(s)!');

    if (i >= 3) {
      print('Cancelling foo task...');
      foo.cancel();
    }
  });
  
  // Named tasks!
  var greetTask = scheduler.minutes(3, (String message) => print(message), name: 'greet');
  
  // You can still access services, etc., and thus manipulate databases from tasks.
  scheduler.once(() {
    app.service('foo').create({'foo': 'bar'});
  });

  // If you never start the scheduler, no tasks will ever run.
  await scheduler.start();
  
  // Run a named task
  var result = await scheduler.run('greet', ['Hello, world!']);
}
```

Make sure to start the scheduler. Otherwise, your tasks will never run:

```dart
main() async {
  // ...
  await scheduler.start();
}
```

You can also listen to a `Stream` of a task's results:

```dart
main() async {
  // ...
  var task = scheduler.minutes(3, fibonacci, args: [13]);
  var fib13 = await task.results.first;
}
```

## Multithreading
Galileo's task engine also supports communication over isolates, which allows you to run all
tasks in a separate thread from the server, without losing performance.

For example, if your processor has 4 cores, you might spawn 4 total isolates:
  * 3 child isolates, all running the server
  * 1 master isolate, which runs the task engine
  
The master isolate can be dedicated to just running tasks, with no HTTP responsibility.
The child isolates only have to worry about serving your application to the Web. 

The `GalileoTaskScheduler` has a `receivePort` that it uses to communicate with clients.

To access the scheduler as a client, instantiate a `GalileoTaskClient`. The constructor accepts a single
`SendPort`, which in this case comes from the scheduler.

**IMPORTANT:** If you *want* to send the return value of task functions to clients, then set
`sendReturnValues` to `true` in the `GalileoTaskScheduler` constructor. If so, then the results of
your task callbacks will have to be primitive Dart values, serializable over SendPorts.

Use this as a mechanism to query the state of the master isolate. You might find that you won't need it,
though.

```dart
main() async {
  var nInstances = Platform.numberOfProcessors - 1;
  
  // This instance won't actually serve HTTP, we just use it for DI.
  var app = await createServer();
  var scheduler = new GalileoTaskScheduler(app);
  
  // Start listening, running tasks, etc.
  await scheduler.start();
  
  for (int i = 0; i < nInstances; i++) {
    // Spawn child nodes now. Make sure to send the scheduler's SendPort.
    Isolate.spawn(isolateMain, [i, scheduler.receivePort.sendPort]);
  }
}

/// The code that runs in the child nodes, i.e., the ones running the application.
void isolateMain(List args) {
  int id = args[0];
  SendPort masterPort = args[1];
  var app = new Galileo.custom(startShared);
  
  // Hook up a task client, then start the server.
  app.configure(taskClientPlugin(masterPort)).then((_) async {
    var server = await app.startServer(InternetAddress.ANY_IP_V4, 3000);
    print('Instance #$id listening at http://${server.address.address}:${server.port}');
  });
}

/// A simple plug-in that connects a server instance to the master task scheduler.
GalileoConfigurer taskClientPlugin(SendPort masterPort) {
  return (Galileo app) async {
    var client = new GalileoTaskClient(masterPort);
    await master.connect(); // Await a connection...
    await master.connect(timeout: new Duration(seconds: 30)); // Optional timeout.
    
    // If we inject the GalileoTaskClient as a singleton, we can access it in routes.
    app.container.singleton(client);
    
    // We can dispatch tasks, without waiting for the result.
    app.get('/dispatch', (GalileoTaskClient client) {
      client.run('foo', args: ['bar']);
    });
    
    // We can also await the results of tasks.
    app.get('/fibonacci/:number([0-9]+)', (GalileoTaskClient client, String number) async {
      var n = int.parse(number);
      var taskResult = await client.run('fibonacci', args: [n]);
      
      if (!taskResult.successful) {
        // Access error and stack trace on failure
        print(taskResult.error);
        print(taskResult.stack);
        throw new GalileoHttpException.notProcessable();
      }
      
      // If `sendReturnValues` is `true` in our `GalileoTaskScheduler`, then we can
      // also access the value returned from the task function.
      var computation = task.value;
      return {'value': computation};
    });
  };
}
```

## Sockets
Applications of very large scale will likely run on multiple machines; in such a case, mere multi-threading
will not do the job.

Luckily, `package:galileo_task` also supports communication over sockets. This can occur at the same time as
communication over isolates, so you can use both together in your application.

To bind the scheduler to a socket, you must pass it to the constructor.

```dart
main() async {
  var socket = await ServerSocket.bind(InternetAddress.ANY_IP_V4, 5671);
  var app = await createServer();
  var scheduler = new GalileoTaskScheduler(app, socket: socket);
  
  // Task configuration...
  
  // Calling `start` will also listen on the socket, if any.
  await scheduler.start(); 
}
```

And then, to connect a client, it's almost the same process:
```dart
main() async {
  var app = await createServer();
  var client = await GalileoTaskClient.connectSocket(InternetAddress.LOOPBACK_IP_V4, 5671);
 
  // You can still inject for DI.
  //
  // Just make sure to explicitly pass the right type.
  app.container.singleton(client, as: GalileoTaskClient);
  
}
```


## Broadcasting
If you are multi-threading, there may be times when you want to send an impromptu message
to all child nodes. Use `GalileoTaskScheduler.broadcast` to achieve this.

Whatever you broadcast should be a primitive Dart value; otherwise, it will not be serializable over
a `SendPort` or `Socket`.

```dart
main() {
  // ...
  scheduler.broadcast({
    'michael': 'jackson'
  });
}
```
