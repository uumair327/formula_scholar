import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_log_tags.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/premium_tier.dart';
import '../../domain/entities/user_entitlements.dart';

abstract interface class PremiumLocalDataSource {
  Future<UserEntitlements> getEntitlements();
  Future<void> saveEntitlements(UserEntitlements entitlements);
  Future<void> clearEntitlements();
}

@LazySingleton(as: PremiumLocalDataSource)
class PremiumLocalDataSourceImpl implements PremiumLocalDataSource {
  static const String _boxName = 'fs_premium_entitlements_box';
  static const String _keyTier = 'entitlement_tier';
  static const String _keyExpiresAt = 'entitlement_expires_at';
  static const String _keyIsLifetime = 'entitlement_is_lifetime';
  static const String _keyIsTrial = 'entitlement_is_trial';
  static const String _keyPerks = 'entitlement_unlocked_perks';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }
    return Hive.openBox<dynamic>(_boxName);
  }

  @override
  Future<UserEntitlements> getEntitlements() async {
    try {
      final box = await _openBox();
      final tierIndex = box.get(_keyTier, defaultValue: PremiumTier.free.index) as int;
      final expiresMillis = box.get(_keyExpiresAt) as int?;
      final isLifetime = box.get(_keyIsLifetime, defaultValue: false) as bool;
      final isTrial = box.get(_keyIsTrial, defaultValue: false) as bool;
      final perksRaw = box.get(_keyPerks, defaultValue: <String>[]) as List<dynamic>;

      final tier = PremiumTier.values[tierIndex.clamp(0, PremiumTier.values.length - 1)];
      final expiresAt = expiresMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(expiresMillis)
          : null;

      return UserEntitlements(
        tier: tier,
        expiresAt: expiresAt,
        isLifetime: isLifetime,
        isTrialActive: isTrial,
        unlockedPerks: perksRaw.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      AppLogger.warning('Failed to load entitlements from Hive, using free defaults: $e',
          tag: AppLogTags.premiumDataSource);
      return UserEntitlements.free;
    }
  }

  @override
  Future<void> saveEntitlements(UserEntitlements entitlements) async {
    try {
      final box = await _openBox();
      await box.put(_keyTier, entitlements.tier.index);
      if (entitlements.expiresAt != null) {
        await box.put(_keyExpiresAt, entitlements.expiresAt!.millisecondsSinceEpoch);
      } else {
        await box.delete(_keyExpiresAt);
      }
      await box.put(_keyIsLifetime, entitlements.isLifetime);
      await box.put(_keyIsTrial, entitlements.isTrialActive);
      await box.put(_keyPerks, entitlements.unlockedPerks);
    } catch (e, st) {
      AppLogger.error('Failed to save entitlements to Hive',
          tag: AppLogTags.premiumDataSource, error: e, stackTrace: st);
    }
  }

  @override
  Future<void> clearEntitlements() async {
    final box = await _openBox();
    await box.clear();
  }
}
