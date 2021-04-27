/// Command-line client library for the Galileo framework.
library galileo_client.cli;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:galileo_json_god/galileo_json_god.dart' as god;
import 'package:path/path.dart' as p;
import 'galileo_client.dart';
import 'base_galileo_client.dart';
export 'galileo_client.dart';

/// Queries an Galileo server via REST.
class Rest extends BaseGalileoClient {
  final List<Service> _services = [];

  Rest(String path) : super(http.Client() as http.BaseClient, path);

  @override
  Service<Id, Data> service<Id, Data>(String path, {Type type, GalileoDeserializer deserializer}) {
    var url = baseUrl.replace(path: p.join(baseUrl.path, path));
    var s = RestService<Id, Data>(client, this, url, type);
    _services.add(s);
    return s;
  }

  @override
  Stream<String> authenticateViaPopup(String url, {String eventName = 'token'}) {
    throw UnimplementedError('Opening popup windows is not supported in the `dart:io` client.');
  }

  @override
  Future close() async {
    await super.close();
    await Future.wait(_services.map((s) => s.close())).then((_) {
      _services.clear();
    });
  }
}

/// Queries an Galileo service via REST.
class RestService<Id, Data> extends BaseGalileoService<Id, Data> {
  final Type type;

  RestService(http.BaseClient client, BaseGalileoClient app, url, this.type) : super(client, app, url);

  @override
  Data deserialize(x) {
    print(x);
    if (type != null) {
      return x.runtimeType == type ? x as Data : god.deserializeDatum(x, outputType: type) as Data;
    }

    return x as Data;
  }

  @override
  String makeBody(x) {
    print(x);
    if (type != null) {
      return super.makeBody(god.serializeObject(x));
    }

    return super.makeBody(x);
  }
}
