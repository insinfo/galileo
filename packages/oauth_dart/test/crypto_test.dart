import 'package:oauth/client.dart' as oauth;
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  test("GET secret", () {
    var tokens = new oauth.Tokens(
        consumerId:  "consumer",
        consumerKey: "remusnoc",
        userId: "user",
        userKey: "resu");
    var nonce   = "1234";
    
    var req = new http.Request("GET", Uri.parse("http://example.com/?a=1&b=2"));
    var params = oauth.generateParameters(req, tokens, nonce, 1398030869);
    
    expect(params['oauth_signature'], equals("SUmV0pnBNRvm57z69++0qAlg5Qk="));
  });
}
