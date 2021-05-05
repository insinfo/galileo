import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'server.dart';

class HttpRequestAdapter implements RequestAdapter {
  HttpRequest _request;
  HttpRequestAdapter(this._request);
  
  String get method => _request.method;
  
  String getHeader(String named) => _request.headers[named].join(", ");
  
  String get mimeType {
    var ct = _request.headers.contentType;
    if(ct != null) {
      return ct.mimeType;
    } else {
      return null;
    }
  }
  
  Encoding get encoding {
    var ct = _request.headers.contentType;
    if(ct != null) {
      return Encoding.getByName(ct.charset);
    } else {
      return null;
    }
  }
  
  Uri get requestedUri => _request.requestedUri;
  
  Stream<List<int>> body_ = null;
  Stream<List<int>> get body {
    if (body_ == null) {
      body_ = _request.asBroadcastStream();
    }
    return body_;
  }
}
