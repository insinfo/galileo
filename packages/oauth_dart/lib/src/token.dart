library oauth.token;
import 'dart:convert';
import 'dart:typed_data';
import 'utils.dart' as utils;
import 'package:crypto/crypto.dart' as crypto;
import 'package:cipher/cipher.dart';
import 'package:cipher/random/secure_random_base.dart';
import 'package:bignum/bignum.dart';
import 'core.dart';

const Base64Codec _base64 = const Base64Codec.urlSafe();

/// Bundles together the public and secret portions of an OAuth token pair.
abstract class Tokens {
  /// The token (public) ID
  String get consumerId;
  String get userId;
  
  /// The type of the token
  String get type;
  
  /** Constructs a new token. Type may be either supported key type 
   * (RSA-SHA1 or HMAC-SHA1).
   * 
   * If constructing a HMAC-SHA1 token, then [consumerKey] and [userKey] should 
   * be a string version of the HMAC secret key.
   * 
   * If constructing a RSA-SHA1 token, then [consumerKey] and [userKey] should 
   * be a JWK encoded RSA key
   * 
   * For finer grained control, use [HmacSha1Tokens] or [RsaSha1Tokens] directly
   */
  factory Tokens({
    String consumerId, String consumerKey,
    String userId, String userKey,
    String type : "HMAC-SHA1"})
  {
    assert(consumerId != null);
    if(type == "HMAC-SHA1") {
      return new HmacSha1Tokens(
          consumerId: consumerId, consumerKey: consumerKey, 
          userId: userId, userKey: userKey); 
    } else if(type == "RSA-SHA1") {
      return new RsaSha1Tokens(
          consumerId: consumerId, consumerKey: consumerKey, 
          userId: userId, userKey: userKey);
    } else {
      throw new ArgumentError("Unknown key type ${type}");
    }
  }
  
  Tokens.chain();
  
  /** Sign [value] using this token, returning the signature */ 
  List<int> sign(List<int> value);
  
  /** Verify [signature] is correct for [value] using this token */
  bool      verify(List<int> signature, List<int> value);
}

class HmacSha1Tokens extends Tokens {
  /// The shared secret
  final String consumerId;
  final String consumerSecret;
  final String userId;
  final String userSecret;
  
  String get type => "HMAC-SHA1";
  
  HmacSha1Tokens({String this.consumerId, String consumerKey,
                String this.userId, String userKey})
      : super.chain()
      , consumerSecret = consumerKey
      , userSecret     = userKey
  {
    assert(consumerId != null && consumerKey != null && 
        (userId == null || (userId != null && userKey != null)));  
  }
  
  List<int> _computeKey() {
    List<int> res = new List<int>();
    res.addAll(oauthEncode(consumerSecret));
    res.add($amp);
    if(userId != null)
      res.addAll(oauthEncode(userSecret));
    return res;
  }

  
  List<int> sign(List<int> value) {
    var secret = _computeKey();    
    var mac = new crypto.Hmac(crypto.sha1, secret);
    return mac.convert(value).bytes;
  }
  
  bool verify(List<int> signature, List<int> value) {
    List<int> sig = sign(value);
    
    if(sig.length != signature.length)
      return false;
    
    for(var i = 0; i < sig.length; i++) {
      if(sig[i] != signature[i]) 
        return false; 
    }
    return true;
  }
}

BigInteger _b64bigint(String str) {
  return new BigInteger(_base64.decode(str));
}

bool _checkContains(Map map, List params, String error, bool need) {
  bool expect = map.containsKey(params.removeLast());
  for(var k in params) {
    if(expect != map.containsKey(k)) {
      throw new ArgumentError(error);
    }
  }

  if(need && !expect) {
    throw new ArgumentError(error);
  }
  return expect;
}

// impl. of Cipher's SecureRandom which just uses our getRandomBytes
class _SecureRandom extends SecureRandomBase {
  String get algorithmName => "OAuth.getRandomBytes";
  List<int> bytes;
  
  void seed(CipherParameters params) {}

  int nextUint8() {
    if(bytes == null || bytes.isEmpty) {
      bytes = utils.getRandomBytes(128);
    }
    
    return bytes.removeLast();
  }
  
  static var INSTANCE = new _SecureRandom();
}

class _KeyPair {
  _KeyPair(this.public, this.private);
  final RSAPublicKey  public;
  final RSAPrivateKey private;
  
  factory _KeyPair.decode(String key) {
    assert(key != null);
    Map<String, dynamic> vals = JSON.decode(key);
    if(vals.containsKey("kty") && vals["kty"] != "RSA") {
      throw new ArgumentError("JWK type must be RSA");
    }
    
    if(vals.containsKey("use") && vals["use"] != "sig") {
      throw new ArgumentError("If specified, JWK use must be 'sig'");
    }
    
    _checkContains(vals, ['n', 'e'], 
        "Key does not specify all public key parameters", true);
    var n = _b64bigint(vals['n']);
    var e = _b64bigint(vals['e']);
    var pubKey = new RSAPublicKey(n, e);
    
    var privKey = null;
    if(_checkContains(vals, ['d', 'p', 'q'], 
        "Key does not specify all necessary private key parameters (d, p, q)", 
        false)) {
      var d = _b64bigint(vals['d']);
      var p = _b64bigint(vals['p']);
      var q = _b64bigint(vals['q']);
      privKey = new RSAPrivateKey(n, d, p, q);
    }
    
    return new _KeyPair(pubKey, privKey);
  }
  
  static _KeyPair NULL = new _KeyPair(null, null); 
}



class RsaSha1Tokens extends Tokens {
  String get type => "RSA-SHA1";
  final String        consumerId;
  final RSAPublicKey  consumerPublicKey;
  final RSAPrivateKey consumerPrivateKey;

  final String        userId;
  final RSAPublicKey  userPublicKey;
  final RSAPrivateKey userPrivateKey;
  
  /** Creates RSA-SHA1 tokens from JSON Web Token encoded RSA keys */
  factory RsaSha1Tokens({
    String consumerId, 
    String consumerKey,
    String userId, 
    String userKey})
  {
    _KeyPair consumer = new _KeyPair.decode(consumerKey);
    _KeyPair user = _KeyPair.NULL;
    
    if(userId != null) {
      user = new _KeyPair.decode(userKey);
    }
    
    return new RsaSha1Tokens.fromKeys(
        consumerId:         consumerId, 
        consumerPublicKey:  consumer.public,
        consumerPrivateKey: consumer.private,
        userId:             userId,
        userPublicKey:      user.public,
        userPrivateKey:     user.private);
  }
  
  /** Creates an RSA-SHA1 token from pairs of Cipher keys */
  RsaSha1Tokens.fromKeys({
    String this.consumerId, RSAPublicKey this.consumerPublicKey, RSAPrivateKey this.consumerPrivateKey,
    String this.userId,     RSAPublicKey this.userPublicKey,     RSAPrivateKey this.userPrivateKey}) 
    : super.chain()
  {
    assert(consumerId != null  && this.consumerPublicKey != null);
    assert(userId == null || this.userPublicKey != null);
    assert(this.consumerPrivateKey != null || this.consumerPublicKey == null);
    assert(this.userPrivateKey != null || this.userPublicKey == null);
    assert((this.consumerPrivateKey == null) == (this.userPrivateKey == null));
  }
  
  List<int> sign(List<int> body) {
    var signer = new Signer("SHA-1/RSA");
    var privateKey = consumerPrivateKey;
    
    if(userPrivateKey != null)
      privateKey = userPrivateKey;
    
    var params = new ParametersWithRandom(new PrivateKeyParameter(privateKey), _SecureRandom.INSTANCE);
    signer.init(true,  params);
    return signer.generateSignature(body).bytes;
  }
  
  bool verify(List<int> signature, List<int> body) {
    var signer = new Signer("SHA-1/RSA");
    var publicKey = consumerPublicKey;
    
    if(userPublicKey != null)
      publicKey = userPublicKey;
    
    var params = new ParametersWithRandom(new PublicKeyParameter(publicKey), _SecureRandom.INSTANCE);
    signer.init(false,  params);
    return signer.verifySignature(body, new RSASignature(new Uint8List.fromList(body)));
  }
}