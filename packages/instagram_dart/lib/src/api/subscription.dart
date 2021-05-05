import 'dart:async';
import '../models/models.dart';

/// Manages Instagram subscriptions.
///
/// https://www.instagram.com/developer/subscriptions/
abstract class SubscriptionManager {
  /// Lists the application's current subscriptions.
  Future<List<Subscription>> fetchAll();

  /// Creates a new subscription.
  Future<Subscription> create(String object, String aspect, String verifyToken, String callbackUrl);

  /// Deletes a subscription by ID.
  Future<bool> delete(String subscriptionId);

  /// Deletes a subscription by `object`..
  Future<bool> deleteByObject(String object);

  /// Deletes all subscriptions.
  Future<bool> deleteAll();
}