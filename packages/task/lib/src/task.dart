import 'dart:async';

/// Represents an asynchronous task that has been scheduled to run at a specific interval.
abstract class Task {
  /// The name of this task.
  String get name;

  /// The frequency at which this task should run.
  Duration get frequency;

  /// Fires the events of running this task.
  Stream get results;

  /// Cancels this task, and prevents it from running again.
  Future cancel();
}
