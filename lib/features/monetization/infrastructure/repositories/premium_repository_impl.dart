import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_log_tags.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/premium_plan.dart';
import '../../domain/entities/user_entitlements.dart';
import '../../domain/ports/premium_repository_port.dart';
import '../adapters/premium_service_adapter.dart';
import '../datasources/premium_local_data_source.dart';

@LazySingleton(as: PremiumRepositoryPort)
class PremiumRepositoryImpl implements PremiumRepositoryPort {
  PremiumRepositoryImpl(
    this._localDataSource,
    this._serviceAdapter,
  );

  final PremiumLocalDataSource _localDataSource;
  final PremiumServiceAdapter _serviceAdapter;
  final StreamController<UserEntitlements> _entitlementsController =
      StreamController<UserEntitlements>.broadcast();

  @override
  Stream<UserEntitlements> get onEntitlementsChanged =>
      _entitlementsController.stream;

  @override
  Future<UserEntitlements> getUserEntitlements() async {
    return _localDataSource.getEntitlements();
  }

  @override
  Future<List<PremiumPlan>> getAvailablePlans() async {
    return _serviceAdapter.fetchStorePlans();
  }

  @override
  Future<UserEntitlements> purchasePlan(PremiumPlan plan) async {
    AppLogger.info('Initiating purchase for plan: ${plan.id} (${plan.title})',
        tag: AppLogTags.premiumRepo);

    final success = await _serviceAdapter.executePurchase(plan);
    if (!success) {
      throw Exception('Purchase cancelled or rejected by store.');
    }

    final isLifetime = plan.interval == BillingInterval.lifetime;
    final expiresAt = isLifetime
        ? null
        : plan.interval == BillingInterval.annual
            ? DateTime.now().add(const Duration(days: 365))
            : DateTime.now().add(const Duration(days: 30));

    final updated = UserEntitlements(
      tier: plan.tier,
      expiresAt: expiresAt,
      isLifetime: isLifetime,
      isTrialActive: plan.hasTrial,
      unlockedPerks: plan.features,
    );

    await _localDataSource.saveEntitlements(updated);
    _entitlementsController.add(updated);
    AppLogger.info('Successfully activated premium tier: ${updated.tier.displayName}',
        tag: AppLogTags.premiumRepo);
    return updated;
  }

  @override
  Future<UserEntitlements> restorePurchases() async {
    AppLogger.info('Restoring previous purchases', tag: AppLogTags.premiumRepo);
    // Fetch persisted entitlements
    final existing = await _localDataSource.getEntitlements();
    _entitlementsController.add(existing);
    return existing;
  }

  @override
  Future<void> updateEntitlements(UserEntitlements entitlements) async {
    AppLogger.info('Manually setting entitlements: ${entitlements.tier.displayName}',
        tag: AppLogTags.premiumRepo);
    await _localDataSource.saveEntitlements(entitlements);
    _entitlementsController.add(entitlements);
  }
}
