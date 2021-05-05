library oauth.test.common;

import 'dart:io';
import 'dart:async';
import 'package:oauth/oauth.dart' as oauth;
import 'package:test/test.dart';

simpleNonceQuery(String consumerToken, String userToken, 
    String nonce, DateTime expiry) {
  return new Future.value(true); 
}

simpleTokenFinder(String type, String consumer, String user) {
  assert(type == "HMAC-SHA1");
  
  var consumerSecret = consumer.toUpperCase();
  var userSecret = null;
  if(user != null)
    userSecret = user.toUpperCase();
  
  return new oauth.Tokens(
      consumerId: consumer,
      consumerKey: consumerSecret,
      userId: user,
      userKey: userSecret);
}

runAllTests(String authority) {
  standardTests(oauth.Client goodClient) => () {
    test("Simple GET", () async {
      var response = await goodClient.get(new Uri.http(authority, "/test/path", {"foo":"bar"}));
      expect(response.statusCode, HttpStatus.OK);
    });
    
    test("Simple POST", () async {
      var response = await goodClient.post(new Uri.http(authority, "/test/path"), body: "Hello, World!");
      expect(response.statusCode, HttpStatus.OK);
    });
    
    test("Form Data POST", () async {
      var response = await goodClient.post(new Uri.http(authority, "/test/path", {"c":"4"}),
          body: "a=1&b=2&c=3",
          headers: {"Content-Type": "application/x-www-form-urlencoded"});
      expect(response.statusCode, HttpStatus.OK);
    });
  };
  
  group("Consumer credentials only",
      standardTests(new oauth.Client(new oauth.Tokens(consumerId: "Hello", consumerKey: "HELLO"))));
  
  group("With user credentials",
      standardTests(new oauth.Client(new oauth.Tokens(consumerId: "Hello", consumerKey: "HELLO", userId: "World", userKey: "WORLD"))));
  
  test("Bad GET", () async {
    var client = new oauth.Client(new oauth.Tokens(consumerId: "bad", consumerKey: "very very bad"));
    var response = await client.get(new Uri.http(authority,  "/"));
    expect(response.statusCode, HttpStatus.FORBIDDEN);
  });
}
