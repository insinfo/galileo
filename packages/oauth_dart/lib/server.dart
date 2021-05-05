/** Server support for OAuth 1.0a with the dart:io [HttpServer] */
library oauth.server;
import 'dart:async';
import 'dart:convert';
import 'package:oauth/src/token.dart';
import 'package:oauth/src/core.dart';
import 'package:oauth/src/utils.dart';
export 'package:oauth/src/token.dart' show Tokens;

final _paramRegex = new RegExp(r'^\s*(\w+)\s*=\s*"([^"]*)"\s*$');
class _NotAuthorized implements Exception {}
void _require(bool test) { if(!test) throw new _NotAuthorized(); }

/** Invoked by `isAuthorized` in order to look up the tokens for a request
 * 
 * If the `oauth_token` authorization header parameter was missing, null 
 * string will be passed as `userKey`. In this case, it is expected that 
 * the user credentials will be absent from the returned Tokens object  
 */
typedef Future<Tokens> TokenFinder(
    String signatureMethod, 
    String consumerKey, 
    String userKey);

/** Invoked by `isAuthorized` in order to validate the non-reuse of the request
 *  nonce.
 *  
 *  Per the OAuth specification, the combination of the consumer key, 
 *  user token key and nonce must be unique per distinct timestamp.
 *  
 *  Instead of the timestamp, this library passes the point in time at which
 *  the signature will expire, based upon the `timestampLeeway` parameter passed
 *  to `isAuthorized`. Therefore, there is a 1:1 mapping between request 
 *  timestamps and values passed to this function.
 *  
 *  The `expiry` value is computed as the timestamp passed in the request plus
 *  two times the `timestampLeeway` value, in order to avoid risk of attack due
 *  to server clock skew.
 *  
 *  The implementation should look up the combination of the parameters in a
 *  database to ensure they have not already been used. Following this, it 
 *  should insert the values of the passed parameters into a database to prevent 
 *  token reuse.
 *  
 *  The implementation should implement a process which periodically sweeps 
 *  expired nonce values from the database.
 */
typedef Future<bool> NonceQuery(String consumerToken, String userToken, 
    String nonce, DateTime expiry);

abstract class RequestAdapter {
  String get method;
  
  String getHeader(String named);
  
  String   get mimeType;
  Encoding get encoding;
  
  Uri get requestedUri;
  
  Stream<List<int>> get body;
}

/** Validates that the request contains a valid OAuth signature.
 * 
 * The request parameters will be validated, and then [tokenFinder] will be
 * invoked in order to look up the secrets(s) associated with the request.
 * Finally, the signature will be computed and compared to the passed value
 * to ensure that the request is to be authorized.
 * 
 * [timestampLeeway] may be specified, which determines the maximum difference
 * permitted between the request timestamp and the present time. The default
 * value is 10 minutes. You should not vary this value across multiple requests
 * as doing so may permit request replay attacks.  
 * 
 * Returns whether the request should be permitted.
 */
Future<bool> isAuthorized(RequestAdapter request, 
                          TokenFinder tokenFinder,
                          NonceQuery  nonceQuery,
                          {Duration timestampLeeway}) {  
  Map<String, String> params;
  String signature;
  Tokens tokens;
  String consumerKey, tokenKey;
  
  timestampLeeway = timestampLeeway != null ? 
      timestampLeeway : new Duration(minutes: 10);
  
  return async.then((_) {
    String authHeader = request.getHeader('Authorization');
    _require(authHeader != null);
    _require(authHeader.startsWith("OAuth "));
    
    authHeader = authHeader.substring(5);
    
    params = new Map<String, String>();
    for(var e in authHeader.split(",")) {
      Match res = _paramRegex.matchAsPrefix(e);
      _require(res != null);
      
      String key   = oauthDecode(res[1]);
      String value = oauthDecode(res[2]);
      params[key] = value;
    }
    
    if(params.containsKey("oauth_version"))
      _require(params["oauth_version"] == "1.0");
    
    _require(params["oauth_signature_method"] == "HMAC-SHA1" ||
        params["oauth_signature_method"] == "RSA-SHA1");
    
    consumerKey   = params["oauth_consumer_key"];
    _require(consumerKey != null);
    
    tokenKey      = params["oauth_token"];
    
    signature = params.remove("oauth_signature");
    _require(signature != null);
    
    var strTimestamp = params["oauth_timestamp"];
    _require(strTimestamp != null);
    
    var timestamp = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(strTimestamp, radix: 10) * 1000, isUtc: true);
    
    var now     = new DateTime.now();
    var diff    = now.difference(timestamp);
    _require(diff < timestampLeeway);
    
    return nonceQuery(consumerKey, tokenKey, params["oauth_nonce"], 
        timestamp.add(timestampLeeway * 2));
  }).then((res) {
    _require(res);
    
    return tokenFinder(params["oauth_signature_method"], consumerKey, tokenKey);
  }).then((Tokens tokens_) {
    tokens = tokens_;
    
    List<Parameter> reqParams = new List<Parameter>.from(mapParameters(params));
    reqParams.addAll(mapParameters(request.requestedUri.queryParameters));
    String mimeType = request.mimeType;
    if(mimeType != null && mimeType == "application/x-www-form-urlencoded") {
      Encoding encoding = request.encoding;
      if(encoding == null) encoding = UTF8;
      return encoding.decodeStream(request.body).then((String data) {
        reqParams.addAll(mapParameters(Uri.splitQueryString(data, encoding: encoding)));
        return reqParams;
      });
    } else {
      return reqParams;
    }
  }).then((List<Parameter> reqParams) {   
    List<int> sigBase = computeSignatureBase(request.method, request.requestedUri, reqParams);
    return tokens.verify(const Base64Codec.urlSafe().decode(signature), sigBase);
  }).catchError((_) => false, test: (e) => e is _NotAuthorized);
}
