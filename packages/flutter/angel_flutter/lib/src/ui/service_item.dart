// import 'dart:async';
import 'package:angel_client/angel_client.dart';
// import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

// Asynchronously eads an item from a [service], and displays its result.
class ServiceItemBuilder<Id, Data> extends StatefulWidget {
  final Id id;
  final Service<Id, Data> service;
  final Widget Function(BuildContext, Data) builder;
  final Widget Function(BuildContext) loadingBuilder;
  final Widget Function(BuildContext, Object) errorBuilder;
  // final Equality<Id> idEquality;

  const ServiceItemBuilder({
    Key key,
    @required this.id,
    @required this.service,
    @required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    // this.idEquality = const DefaultEquality()
  }) : super(key: key);

  @override
  _ServiceItemBuilderState<Id, Data> createState() =>
      _ServiceItemBuilderState();
}

class _ServiceItemBuilderState<Id, Data>
    extends State<ServiceItemBuilder<Id, Data>> {
  // var _subs = <StreamSubscription<Data>>[];
  Data _current;
  Object _error;

  @override
  void initState() {
    super.initState();

    void onData(Data data) {
      setState(() {
        _current = data;
      });
    }

    void onError(e) {
      setState(() {
        _error = e;
      });
    }

    widget.service.read(widget.id).then(onData).catchError(onError);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder(context, _error);
      } else {
        return ErrorWidget(_error);
      }
    } else if (_current != null) {
      return widget.builder(context, _current);
    } else if (widget.loadingBuilder != null) {
      return widget.loadingBuilder(context);
    } else {
      return SizedBox.shrink();
    }
  }
}
