import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [ProfileRepositoryPort].
///
/// Delegates to [ProfileDataSourcePort] and wraps results in [Result].
@LazySingleton(as: ProfileRepositoryPort)
class ProfileRepositoryImpl implements ProfileRepositoryPort {
  final ProfileDataSourcePort _dataSource;

  const ProfileRepositoryImpl({
    required ProfileDataSourcePort dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<UserProfile>> getUserProfile() async {
    AppLogger.trace('getUserProfile() called', tag: AppLogTags.profileRepo);
    try {
      final result = await _dataSource.getUserProfile();
      AppLogger.info(
        'getUserProfile() succeeded: ${result.name}',
        tag: AppLogTags.profileRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getUserProfile() failed',
        tag: AppLogTags.profileRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load user profile',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<ProfileStat>>> getProfileStats() async {
    AppLogger.trace('getProfileStats() called', tag: AppLogTags.profileRepo);
    try {
      final result = await _dataSource.getProfileStats();
      AppLogger.info(
        'getProfileStats() succeeded: ${result.length} stats',
        tag: AppLogTags.profileRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getProfileStats() failed',
        tag: AppLogTags.profileRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load profile stats',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<SettingsItem>>> getSettingsItems() async {
    AppLogger.trace(
      'getSettingsItems() called',
      tag: AppLogTags.profileRepo,
    );
    try {
      final result = await _dataSource.getSettingsItems();
      AppLogger.info(
        'getSettingsItems() succeeded: ${result.length} items',
        tag: AppLogTags.profileRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getSettingsItems() failed',
        tag: AppLogTags.profileRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load settings items',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
