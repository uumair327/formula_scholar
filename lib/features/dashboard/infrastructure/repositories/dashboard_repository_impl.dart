import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [DashboardRepositoryPort].
///
/// Delegates to [DashboardDataSourcePort] (abstract) for data retrieval.
/// The actual backend (local, Firebase, Supabase) is resolved by
/// the DI container — this class never knows which one.
///
/// Returns [Result] to enforce typed error handling at the boundary.
@LazySingleton(as: DashboardRepositoryPort)
class DashboardRepositoryImpl implements DashboardRepositoryPort {
  final DashboardDataSourcePort _dataSource;
  final DashboardCachePort _cache;

  const DashboardRepositoryImpl({
    required DashboardDataSourcePort dataSource,
    required DashboardCachePort cache,
  }) : _dataSource = dataSource,
       _cache = cache;

  @override
  Future<Result<StudyProgress>> getStudyProgress() async {
    AppLogger.trace('getStudyProgress() called', tag: AppLogTags.dashboardRepo);
    try {
      final result = await _dataSource.getStudyProgress();
      await _cache.cacheStudyProgress(result);
      AppLogger.info(
        'getStudyProgress() succeeded: '
        '${result.masteryPercentage}% mastery',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      final cached = await _cache.getStudyProgress();
      if (cached != null) {
        AppLogger.warning(
          'getStudyProgress() remote failed, using cached data',
          tag: AppLogTags.dashboardRepo,
        );
        return Success(cached);
      }

      AppLogger.error(
        'getStudyProgress() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        ServerFailure(
          message: 'Failed to load study progress',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardId,
    String gradeId,
  ) async {
    AppLogger.trace('getSubjects() called', tag: AppLogTags.dashboardRepo);
    try {
      final result = await _dataSource.getSubjects(boardId, gradeId);
      await _cache.cacheSubjects(boardId, gradeId, result);
      AppLogger.info(
        'getSubjects() succeeded: ${result.length} subjects',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      final cached = await _cache.getSubjects(boardId, gradeId);
      if (cached.isNotEmpty) {
        AppLogger.warning(
          'getSubjects() remote failed, using cached data',
          tag: AppLogTags.dashboardRepo,
        );
        return Success(cached);
      }

      AppLogger.error(
        'getSubjects() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        ServerFailure(
          message: 'Failed to load subjects',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Result<List<RecentStudy>>> getRecentStudies() async {
    AppLogger.trace('getRecentStudies() called', tag: AppLogTags.dashboardRepo);
    try {
      final result = await _dataSource.getRecentStudies();
      await _cache.cacheRecentStudies(result);
      AppLogger.info(
        'getRecentStudies() succeeded: ${result.length} studies',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      final cached = await _cache.getRecentStudies();
      if (cached.isNotEmpty) {
        AppLogger.warning(
          'getRecentStudies() remote failed, using cached data',
          tag: AppLogTags.dashboardRepo,
        );
        return Success(cached);
      }

      AppLogger.error(
        'getRecentStudies() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(
        ServerFailure(
          message: 'Failed to load recent studies',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
