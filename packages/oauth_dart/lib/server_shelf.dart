import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'server.dart';

/// Adapts a Shelf request into a form which the OAuth package can use.
/// 
/// The Shelf request's body is single consumer. Therefore, when this package
/// reads the request body it exhausts it.
/// 
/// As a result, once the [isAuthorized] call is complete, you should recreate
/// the Shelf Request object as necessary with the broadcast stream duplicate
/// of the body that this class has created. The [didReadBody] property will
/// inform you if you need to do this; if you do, then the broadcast stream
/// version of the body can be acquired from [body].
/// 
/// You can use the [getRequest] method to do this on your behalf.
class ShelfRequestAdapter implements RequestAdapter {
  Request           _request;
  Stream<List<int>> _body;
  
  ShelfRequestAdapter(this._request);
  
  String get method => _request.method;
  
  String getHeader(String named) => _request.headers[named];
  
  String get mimeType => _request.mimeType;
  
  Encoding get encoding => _request.encoding;
  
  Uri get requestedUri => _request.requestedUri;
  
  Stream<List<int>> get body {
    if(_body == null) {
      _body = _request.read().asBroadcastStream();
    }
    return _body;
  }
  
  /// Returns whether the request body was read (and therefore if the request
  /// object needs regenerating)
  bool get didReadBody => _body != null;
  
  /// Returns the request object passed in if the body was not read, else 
  /// creates a Request object identical to the original in every way except
  /// for permitting the body to be read again.
  /// 
  /// Must be called after the isAuthorized call has completed.
  Request getRequest() {
    if(didReadBody) {
      return _request.change(body: _body);
    } else {
      return _request;
    }
  }
}
