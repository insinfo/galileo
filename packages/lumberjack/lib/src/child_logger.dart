import 'hierarchical_logger.dart';
import 'log.dart';

class ChildLogger extends HierarchicalLogger {
  final HierarchicalLogger parent;
  final bool bubbleOnly;

  ChildLogger(this.parent, String name, this.bubbleOnly) : super(name);

  String get fullName {
    if (parent is ChildLogger) {
      return '${(parent as ChildLogger).fullName}.$name';
    } else {
      return '${parent.name}.$name';
    }
  }

  @override
  void add(Log log) {
    if (!bubbleOnly) {
      super.add(log);
    }

    parent.addFromChild(this, log);
  }
}
