import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'cookie_signer.dart';

class CsrfToken {
  final String value;

  CsrfToken(this.value);
}

class CsrfFilter {
  final CookieSigner cookieSigner;

  CsrfFilter(this.cookieSigner);

  Future<CsrfToken> readCsrfToken(RequestContext req) async {
    
  }
}
