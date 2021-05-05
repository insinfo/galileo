/** Client support for OAuth 1.0a with [http.BaseClient]
 */
library oauth.client;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:oauth/src/utils.dart';
import 'package:oauth/src/core.dart';
import 'package:oauth/src/token.dart';
import 'package:http/http.dart' as http;
export 'package:oauth/src/token.dart' show Tokens;

const Base64Codec _base64 = const Base64Codec();

/** Generate the parameters to be included in the `Authorization:` header of a
 *  request. Generally you should prefer use of [signRequest] or [Client] 
 */
Map<String, String> generateParameters(
    http.Request request,
    Tokens tokens, 
    String nonce,
    int timestamp) {
  Map<String, String> params = new Map<String, String>();
  params["oauth_consumer_key"] = tokens.consumerId;
  if(tokens.userId != null) {
    params["oauth_token"] = tokens.userId;
  }
  
  params["oauth_signature_method"] = tokens.type;
  params["oauth_version"] = "1.0";
  params["oauth_nonce"] = nonce;
  params["oauth_timestamp"] = timestamp.toString();
  
  List<Parameter> requestParams = new List<Parameter>();
  requestParams.addAll(mapParameters(request.url.queryParameters));
  requestParams.addAll(mapParameters(params));
  
  if(request.contentLength != null
      && request.contentLength != 0
      && ContentType.parse(request.headers["Content-Type"]).mimeType == "application/x-www-form-urlencoded") {
    requestParams.addAll(mapParameters(request.bodyFields));
  } 
  
  var sigBase = computeSignatureBase(request.method, request.url, requestParams);
  params["oauth_signature"] = _base64.encode(tokens.sign(sigBase));
  
  return params;
}

/// Produces a correctly formatted Authorization header given a parameter map
String produceAuthorizationHeader(Map<String, String> parameters) {
  return "OAuth " + encodeAuthParameters(parameters);
}

/** Signs [request] using consumer token [consumerToken] and user authorization
 *  [userToken]
 *
 *  If the body of [request] has content type 
 *  `application/x-www-form-urlencoded`, then the request body cannot be 
 *  streaming as the body parameters are required as part of the signature.
 * 
 *  The combination of [consumerToken], [userToken], [nonce] and [timestamp]
 *  must be unique. [timestamp] must be specified in Unix time format (i.e. 
 *  seconds since 1970-01-01T00:00Z)
 */
void signRequest(http.BaseRequest request,
                 Tokens tokens,
                 String nonce,
                 int timestamp) {
  
  var params = generateParameters(request, tokens, nonce, timestamp);
  
  request.headers["Authorization"] = produceAuthorizationHeader(params);
}

/** An implementation of [http.BaseClient] which signs all requests with the
 * provided credentials.
 * 
 */
class Client extends http.BaseClient {
  /// The OAuth tokens. Required.
  Tokens tokens;
  http.BaseClient _client;
  
  /// The wrapped client
  http.BaseClient get client => _client;
  
  /** Constructs a new client, with tokens [consumerToken] and optionally 
   * [userToken]. If [client] is provided, it will be wrapped, else a new 
   * [http.Client] will be created.
   * 
   *  If the body of any request has content type 
   * `application/x-www-form-urlencoded`, then the request cannot be 
   *  streaming as the body parameters are required as part of the signature.
   */
  Client(this.tokens, {http.BaseClient client}):
    _client = client != null ? client : new http.Client();
    
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
      var nonce = getRandomBytes(8);
      String nonceStr = _base64.encode(nonce);
      signRequest(request, tokens, nonceStr,
                  new DateTime.now().millisecondsSinceEpoch ~/ 1000);
      return _client.send(request);
    }
}
