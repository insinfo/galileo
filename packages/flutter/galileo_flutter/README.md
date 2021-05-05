# galileo_flutter
[![Pub](https://img.shields.io/pub/v/galileo_flutter.svg)](https://pub.dartlang.org/packages/galileo_flutter)

Widgets and helpers for developing Flutter clients for galileo applications.

## `galileoAnimatedList`
Found in `package:galileo_flutter/ui/galileo_animated_list.dart`.

![galileoAnimatedList screenshot](https://github.com/galileo-dart/flutter/raw/master/screenshots/todos.png)

Similar to the `FirebaseAnimatedList` widget in `package:firebase_database`, this widget
is a `ListView` that updates itself in real-time, based on a `Service` or `ServiceList`
instance. This plays nicely with WebSockets, REST, polling, and every transport provided by
`package:galileo_client`.

Example usage:

```dart
@override
Widget build(BuildContext context) {
    return new Scaffold(
    body: new RefreshIndicator(
        onRefresh: () => service.index().then((_) => null),
        child: new galileoAnimatedList(
            serviceList: todos,
            primary: true,
            defaultChild: (_) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
            },
            emptyState: (_) {
                return const Center(
                  child: const Text('No todos found.'),
                );
            },
            builder: (ctx, data, animation, index) {
                var todo = new Todo.fromJson(data);
                return new TodoItem(todo, service);
            },
          ),
        ),
    );
}
```