/// Represents the result of running a remote task.
abstract class TaskResult {
  /// Returns `true` if the task terminated without error.
  bool get successful;

  /// Contains information about the error that caused this task to fail.
  String get error;

  /// A stack trace of the error that caused this task to fail.
  String get stack;

  /// The result of a successful task.
  get value;
}
