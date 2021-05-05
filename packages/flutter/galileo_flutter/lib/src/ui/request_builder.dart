import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:galileo_client/galileo_client.dart';

import 'package:http/http.dart' as http;

/// Sends a request to an [app], and displays the result.
class RequestBuilder extends StatefulWidget {
  final Galileo app;
  final url;
  final String method;
  final Map<String, String> headers;
  final String body;
  final Map<String, String> bodyFields;
  final List<int> bodyBytes;
  final Widget Function(BuildContext context, http.Response response) builder;
  final Widget Function(BuildContext context) loadingBuilder;
  final Widget Function(BuildContext context, Object) errorBuilder;

  const RequestBuilder(
      {Key key,
      @required this.app,
      @required this.url,
      @required this.builder,
      this.method = 'GET',
      this.headers = const {},
      this.body,
      this.bodyFields,
      this.bodyBytes,
      this.loadingBuilder,
      this.errorBuilder})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RequestBuilderState();
}

class _RequestBuilderState extends State<RequestBuilder> {
  final AsyncMemoizer<http.Response> _memo = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    var future = _memo.runOnce(() {
      var rq = http.Request(widget.method, Uri.parse(widget.url.toString()));
      rq.headers.addAll(widget.headers);
      if (widget.body != null) rq.body = widget.body;
      if (widget.bodyFields != null) rq.bodyFields = widget.bodyFields;
      if (widget.bodyBytes != null) rq.bodyBytes = widget.bodyBytes;
      return widget.app.send(rq).then(http.Response.fromStream);
    });

    return FutureBuilder<http.Response>(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if (snapshot.hasError) {
          if (widget.errorBuilder != null) return widget.errorBuilder(context, snapshot.error);
        } else if (snapshot.hasData) {
          if (widget.loadingBuilder != null) return widget.loadingBuilder(context);
        } else {
          return widget.builder(context, snapshot.data);
        }

        return SizedBox.shrink();
      },
    );
  }
}
