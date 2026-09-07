import 'dart:async';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_log_tags.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/ad_config.dart';
import '../../domain/entities/ad_density_level.dart';
import '../../domain/entities/ad_placement.dart';
import '../../domain/ports/ad_repository_port.dart';
import '../datasources/ad_local_data_source.dart';

@LazySingleton(as: AdRepositoryPort)
class AdRepositoryImpl implements AdRepositoryPort {
  AdRepositoryImpl(this._localDataSource);

  final AdLocalDataSource _localDataSource;
  final StreamController<AdConfig> _configStreamController =
      StreamController<AdConfig>.broadcast();

  @override
  Stream<AdConfig> get onConfigChanged => _configStreamController.stream;

  @override
  Future<AdConfig> getAdConfig() async {
    return _localDataSource.getAdConfig();
  }

  @override
  Future<void> setAdDensity(AdDensityLevel density) async {
    AppLogger.info('Ad density updated to: ${density.displayName}',
        tag: AppLogTags.adRepo);
    await _localDataSource.setDensity(density);
    final updated = await _localDataSource.getAdConfig();
    _configStreamController.add(updated);
  }

  @override
  Future<int> incrementActionCount() async {
    final count = await _localDataSource.incrementActionCount();
    final updated = await _localDataSource.getAdConfig();
    _configStreamController.add(updated);
    return count;
  }

  @override
  Future<void> recordAdImpression(AdPlacement placement) async {
    AppLogger.info('Recording ad impression for placement: $placement',
        tag: AppLogTags.adRepo);
    await _localDataSource.recordImpression();
    final updated = await _localDataSource.getAdConfig();
    _configStreamController.add(updated);
  }

  @override
  Future<void> resetActionCounter() async {
    await _localDataSource.resetActionCount();
    final updated = await _localDataSource.getAdConfig();
    _configStreamController.add(updated);
  }
}
