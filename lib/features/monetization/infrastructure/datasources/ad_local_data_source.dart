import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_log_tags.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/ad_config.dart';
import '../../domain/entities/ad_density_level.dart';

abstract interface class AdLocalDataSource {
  Future<AdConfig> getAdConfig();
  Future<void> saveAdConfig(AdConfig config);
  Future<int> incrementActionCount();
  Future<void> resetActionCount();
  Future<void> recordImpression();
  Future<void> setDensity(AdDensityLevel density);
}

@LazySingleton(as: AdLocalDataSource)
class AdLocalDataSourceImpl implements AdLocalDataSource {
  static const String _boxName = 'fs_ad_config_box';
  static const String _keyDensity = 'ad_density';
  static const String _keyLastShown = 'ad_last_shown_timestamp';
  static const String _keyActionCount = 'ad_action_count';
  static const String _keyImpressions = 'ad_total_impressions';

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }
    return Hive.openBox<dynamic>(_boxName);
  }

  @override
  Future<AdConfig> getAdConfig() async {
    try {
      final box = await _openBox();
      final densityIndex = box.get(_keyDensity, defaultValue: AdDensityLevel.minimal.index) as int;
      final lastShownMillis = box.get(_keyLastShown) as int?;
      final actionCount = box.get(_keyActionCount, defaultValue: 0) as int;
      final impressions = box.get(_keyImpressions, defaultValue: 0) as int;

      final density = AdDensityLevel.values[densityIndex.clamp(0, AdDensityLevel.values.length - 1)];
      final lastShown = lastShownMillis != null
          ? DateTime.fromMillisecondsSinceEpoch(lastShownMillis)
          : null;

      return AdConfig(
        densityLevel: density,
        lastAdShownAt: lastShown,
        actionCounter: actionCount,
        totalImpressions: impressions,
      );
    } catch (e) {
      AppLogger.warning('Failed to load ad config from Hive, using defaults: $e',
          tag: AppLogTags.adDataSource);
      return const AdConfig();
    }
  }

  @override
  Future<void> saveAdConfig(AdConfig config) async {
    try {
      final box = await _openBox();
      await box.put(_keyDensity, config.densityLevel.index);
      if (config.lastAdShownAt != null) {
        await box.put(_keyLastShown, config.lastAdShownAt!.millisecondsSinceEpoch);
      }
      await box.put(_keyActionCount, config.actionCounter);
      await box.put(_keyImpressions, config.totalImpressions);
    } catch (e, st) {
      AppLogger.error('Failed to save ad config to Hive',
          tag: AppLogTags.adDataSource, error: e, stackTrace: st);
    }
  }

  @override
  Future<int> incrementActionCount() async {
    final box = await _openBox();
    final current = box.get(_keyActionCount, defaultValue: 0) as int;
    final next = current + 1;
    await box.put(_keyActionCount, next);
    return next;
  }

  @override
  Future<void> resetActionCount() async {
    final box = await _openBox();
    await box.put(_keyActionCount, 0);
  }

  @override
  Future<void> recordImpression() async {
    final box = await _openBox();
    final impressions = box.get(_keyImpressions, defaultValue: 0) as int;
    await box.put(_keyImpressions, impressions + 1);
    await box.put(_keyLastShown, DateTime.now().millisecondsSinceEpoch);
    await box.put(_keyActionCount, 0);
  }

  @override
  Future<void> setDensity(AdDensityLevel density) async {
    final box = await _openBox();
    await box.put(_keyDensity, density.index);
  }
}
