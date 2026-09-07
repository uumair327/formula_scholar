import '../entities/premium_plan.dart';
import '../entities/user_entitlements.dart';

/// Contract for premium entitlements, store plans, and purchase management.
abstract interface class PremiumRepositoryPort {
  /// Fetches the user's current entitlements.
  Future<UserEntitlements> getUserEntitlements();

  /// Fetches available subscription and purchase plans.
  Future<List<PremiumPlan>> getAvailablePlans();

  /// Initiates purchase or trial activation for a plan.
  Future<UserEntitlements> purchasePlan(PremiumPlan plan);

  /// Restores existing purchases.
  Future<UserEntitlements> restorePurchases();

  /// Sets entitlements directly (e.g. for testing, promo codes, or admin).
  Future<void> updateEntitlements(UserEntitlements entitlements);

  /// Stream of entitlement updates.
  Stream<UserEntitlements> get onEntitlementsChanged;
}
