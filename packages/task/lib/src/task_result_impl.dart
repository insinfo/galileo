import 'task_result.dart';

class TaskResultImpl implements TaskResult {
  @override
  final bool successful;

  @override
  final String error, stack;

  @override
  final value;

  TaskResultImpl(this.successful, {this.error, this.stack, this.value});

  static TaskResultImpl parse(Map map) => new TaskResultImpl(map['successful'],
      error: map['error'], stack: map['stack'], value: map['value']);

  Map<String, dynamic> toJson() {
    return {
      'successful': successful,
      'error': error,
      'stack': stack,
      'value': value
    };
  }
}
