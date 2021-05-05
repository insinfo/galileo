

# instagram
[![Pub](https://img.shields.io/pub/v/instagram.svg)](https://pub.dartlang.org/packages/instagram_dart)

### NOTE: The old Instagram API is now deprecated; this package will now focus on the Instagram Graph API.

Dart Instagram client library. This library includes support for authentication,
as well as all of the Instagram API v1 endpoints.

The API is entirely documented, for convenience. :+1:

Users of
[galileo](https://galileodart.com)
can use
[`package:galileo_auth_instagram`](https://pub.dartlang.org/packages/galileo_auth_instagram)
to authenticate users with Instagram.

*Coming soon: Subscriptions*

* [Installation and Usage](#installation-and-usage)
* [Authentication](#authentication)
    * [Via Access Token](#via-access-token)
    * [`InstagramApiAuth`](#instagramapiauth)
    * [Implicit Auth](#implicit-auth)
    * [Explicit Auth](#explicit-auth)
* [Constants](#constants)

# Authentication
## Via Access Token
If you already have an access token, you can authenticate a client.

*Note: The `user` property of the `InstagramClient` will be `null`.*

```dart
var client = InstagramApiAuth.authorizeViaAccessToken('<access-token>');
var me = await client.users.self.get();
```

## InstagramApiAuth
To perform authentication, use the `InstagramApiAuth` class. All API scopes are
included as `InstagramApiScope` constants for convenience.

```dart
var auth = new InstagramApiAuth('<client-id>', '<client-secret>',
  redirectUri: Uri.parse('<redirect-uri>'),
  scopes: [
    InstagramApiScope.basic,
    InstagramApiScope.publicContent,
    // ...
  ]
);
```

## Implicit Auth
Applications with no server-side component can implement
[implicit auth](https://www.instagram.com/developer/authentication/).

To get a redirect URI:

```dart
var redirectUri = auth.getImplicitRedirectUri();
window.location.href = redirectUri.toString();
```

## Explicit Auth
This library also supports traditional OAuth2 authentication.

To obtain a redirect URI:

```dart
var redirectUri = auth.getRedirectUri();
var redirectUri = auth.getRedirectUri(state: 'foo.bar=baz');
res.redirect(redirectUri.toString());
```

After you have obtained an authorization code, you can exchange it for an access token,
and receive an `InstagramClient`.

This example is an
[galileo](https://galileo-dart.github.io)
handler:

```dart
app.get('/auth/instagram/callback', (RequestContext req, InstagramApiAuth instaAuth) async {
  var client = await instaAuth.handleAuthorizationCode(req.query['code'], new http.Client());
  var me = await client.users.self.get();
  
  // Do something with the authenticated user...
});
```

You can also manage
[subscriptions](https://www.instagram.com/developer/subscriptions):

```dart
main() {
  var subscriptions = instaAuth.createSubscriptionManager(new http.Client());
}
```

# Endpoints
The `InstagramClient` contains several getters that correspond to endpoints. Each is an abstraction over
a specific Instagram API.

Here is an example with the `relationships` API:

```dart
Future<bool> userFollowsMe(String userId, InstagramClient instagram) async {
  var relationship = await instagram.relationships.toUser(userId).get();
  return relationship.incomingStatus == IncomingStatus.followedBy;
}
```

# Constants
This API includes several classes containing helpful constants:
* `InstagramApiScope`
* `IncomingStatus`
* `OutgoingStatus`
* `RelationshipAction`
* `MediaType`
* `SubscriptionObject`
* `SubscriptionAspect`
