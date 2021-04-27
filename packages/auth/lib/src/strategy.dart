import 'dart:async';
import 'package:galileo_framework/galileo_framework.dart';
import 'options.dart';

/// A function that handles login and signup for an Galileo application.
abstract class AuthStrategy<User> {
  /// Authenticates or rejects an incoming user.
  FutureOr<User> authenticate(RequestContext req, ResponseContext res, [GalileoAuthOptions<User> options]);
}
