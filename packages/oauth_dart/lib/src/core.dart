library oauth.core;
import 'dart:convert';

const int $0    = 0x30;
const int $9    = 0x39;
const int $A    = 0x41;
const int $F    = 0x46;
const int $Z    = 0x5A;
const int $a    = 0x61;
const int $z    = 0x7A;
const int $dash = 0x2D;
const int $dot  = 0x2E;
const int $und  = 0x5F;
const int $til  = 0x7E;
const int $perc = 0x25;
const int $amp  = 0x26;
const int $eq   = 0x3D;

int _hexDigit(int v) {
  return v >= 10 ? $A - 10 + v : $0 + v;
}

List<int> oauthEncode(val) {
  if(val is String)
    val = UTF8.encode(val);
  
  return new List<int>.from(val.expand((int b) {
    if(   (b >= $0 && b <= $9)
       || (b >= $A && b <= $Z)
       || (b >= $a && b <= $z)
       ||  b == $dash || b == $dot
       ||  b == $und  || b == $til) {
      return [b];
    } else {
      return [$perc, _hexDigit(b >> 4), _hexDigit(b & 0xF)];
    }
  }));
}

int _unhexDigit(int v) {
  if(v >= $0 && v <= $9) {
    return v - $0;
  } else if(v >= $A && v <= $F) {
    return v - ($A - 10);
  } else {
    throw new FormatException("Invalid character " + new String.fromCharCode(v) + " when decoding hexadecimal digit");
  }
}

String oauthDecode(val) {
  if(val is String)
    val = val.codeUnits;
  
  List<int> buf = new List<int>();
  for(int i = 0; i < val.length; i++) {
    if(val[i] == $perc) {
      buf.add(_unhexDigit(val[i+1]) << 4 | _unhexDigit(val[i+2]));
      i += 2;
    } else {
      buf.add(val[i]);
    }
  }
  
  return UTF8.decode(buf);
}

class Parameter implements Comparable<Parameter> {
  List<int> _key, _value;
  Parameter(String key, String value) 
      : _key   = oauthEncode(key)
      , _value = oauthEncode(value);
  
  static int _listCmp(List<int> l, List<int> r) {
      int len = l.length < r.length ? l.length : r.length;
      for(int i = 0; i < len; i++) {
        int diff = l[i] - r[i];
        if(diff != 0) return diff;
      }
      
      return l.length - r.length;
  }
  
  int compareTo(Parameter r) {
    int res = _listCmp(_key, r._key);
    if(res == 0)
      res = _listCmp(_value, r._value);
    return res;
  }
  
  List<int> encode() {
    List<int> res = new List<int>();
    res.addAll(_key);
    res.add($eq);
    res.addAll(_value);
    return res;
  }
}

List<int> _foldParameters(List<int> lhs, List<int> rhs) {
  lhs.add($amp);
  lhs.addAll(rhs);
  return lhs;
}

Iterable<Parameter> mapParameters(Map<String, String> map) {
  return map.keys.map((k) => new Parameter(k, map[k]));
}

String encodeAuthParameters(Map<String, String> map) {
  return map.keys
      .map((key) => ASCII.decode(oauthEncode(key)) + "=\"" + ASCII.decode(oauthEncode(map[key])) + "\"")
      .join(", ");
}

String computeBaseUrl(Uri uri) {
  return uri.scheme + "://" + uri.authority + uri.path;
}

List<int> computeSignatureBase(String method, Uri url, List<Parameter> params) {
  params.sort();    
  
  List<int> sigBase = new List<int>();
  sigBase.addAll(oauthEncode(method));
  sigBase.add($amp);
  sigBase.addAll(oauthEncode(computeBaseUrl(url)));
  sigBase.add($amp);
  sigBase.addAll(oauthEncode(params.map((p) => p.encode()).reduce(_foldParameters)));
  
  return sigBase;
}


