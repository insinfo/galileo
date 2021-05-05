import 'package:galileo_client/galileo_client.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// An [AnimatedList] that updates its display when a remote service updates.
///
/// Adapted version of:
/// https://github.com/flutter/plugins/blob/master/packages/firebase_database/lib/ui/firebase_animated_list.dart
class GalileoAnimatedList extends StatefulWidget {
  final Service service;
  final ServiceList serviceList;
  final Widget Function(BuildContext, Object, Animation<double>, int) builder;
  final Widget Function(BuildContext) emptyState;
  final Widget Function(BuildContext) defaultChild;
  final Widget Function(BuildContext, Object) errorChild;
  final Axis scrollDirection;
  final bool reverse;
  final bool primary;
  final bool shrinkWrap;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics physics;
  final ScrollController controller;

  GalileoAnimatedList(
      {Key key,
      this.service,
      this.serviceList,
      @required this.builder,
      this.emptyState,
      this.defaultChild,
      this.errorChild,
      this.scrollDirection: Axis.vertical,
      this.reverse: false,
      this.primary,
      this.shrinkWrap: false,
      this.controller,
      this.physics,
      this.padding})
      : super(key: key) {
    assert(service != null || serviceList != null, 'Either a service or serviceList must be provided.');
  }

  @override
  State createState() {
    return GalileoAnimatedListState();
  }
}

class GalileoAnimatedListState extends State<GalileoAnimatedList> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();
  ServiceList _serviceList;

  bool get _fromService => widget.service != null;

  @override
  void initState() {
    super.initState();
    if (_fromService) {
      _serviceList = ServiceList(widget.service);
    } else {
      _serviceList = widget.serviceList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ServiceList>(
      stream: _serviceList.onChange,
      builder: (BuildContext context, AsyncSnapshot<ServiceList> snapshot) {
        if (widget.errorChild != null && snapshot.hasError) {
          return widget.errorChild(context, snapshot.error);
        }

        if (!snapshot.hasData) {
          return widget.defaultChild != null ? widget.defaultChild(context) : Container();
        }

        if (widget.emptyState != null && snapshot.data.isEmpty) {
          return widget.emptyState(context);
        }

        return AnimatedList(
          key: _animatedListKey,
          itemBuilder: (BuildContext context, int index, Animation<double> animation) {
            return widget.builder(context, snapshot.data[index], animation, index);
          },
          initialItemCount: snapshot.data.length,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          controller: widget.controller,
          primary: widget.primary,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: widget.padding,
        );
      },
    );
  }
}
