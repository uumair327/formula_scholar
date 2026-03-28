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

  const DashboardRepositoryImpl({
    required DashboardDataSourcePort dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Result<StudyProgress>> getStudyProgress() async {
    AppLogger.trace(
      'getStudyProgress() called',
      tag: AppLogTags.dashboardRepo,
    );
    try {
      final result = await _dataSource.getStudyProgress();
      AppLogger.info(
        'getStudyProgress() succeeded: '
        '${result.masteryPercentage}% mastery',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getStudyProgress() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load study progress',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<Subject>>> getSubjects() async {
    AppLogger.trace('getSubjects() called', tag: AppLogTags.dashboardRepo);
    try {
      final result = await _dataSource.getSubjects();
      AppLogger.info(
        'getSubjects() succeeded: ${result.length} subjects',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getSubjects() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load subjects',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  @override
  Future<Result<List<RecentStudy>>> getRecentStudies() async {
    AppLogger.trace(
      'getRecentStudies() called',
      tag: AppLogTags.dashboardRepo,
    );
    try {
      final result = await _dataSource.getRecentStudies();
      AppLogger.info(
        'getRecentStudies() succeeded: ${result.length} studies',
        tag: AppLogTags.dashboardRepo,
      );
      return Success(result);
    } catch (e, stackTrace) {
      AppLogger.error(
        'getRecentStudies() failed',
        tag: AppLogTags.dashboardRepo,
        error: e,
        stackTrace: stackTrace,
      );
      return Error(CacheFailure(
        message: 'Failed to load recent studies',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }
}
