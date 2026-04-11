import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Concrete implementation of [DashboardRepositoryPort].
///
/// Delegates to [DashboardDataSourcePort] (abstract) for data retrieval.
/// The actual backend (local, Firebase, Supabase) is resolved by
/// the DI container — this class never knows which one.
///
/// Uses [safeOperation] for DRY error handling with [DashboardCachePort]
/// fallback for offline-first behaviour.
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
  Future<Result<StudyProgress>> getStudyProgress() {
    return safeOperation(
      tag: AppLogTags.dashboardRepo,
      operation: 'getStudyProgress',
      execute: () async {
        final result = await _dataSource.getStudyProgress();
        await _cache.cacheStudyProgress(result);
        return result;
      },
      fallback: () => _cache.getStudyProgress(),
    );
  }

  @override
  Future<Result<List<Subject>>> getSubjects(
    String boardId,
    String gradeId,
  ) {
    return safeOperation(
      tag: AppLogTags.dashboardRepo,
      operation: 'getSubjects',
      execute: () async {
        final result = await _dataSource.getSubjects(boardId, gradeId);
        await _cache.cacheSubjects(boardId, gradeId, result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getSubjects(boardId, gradeId);
        return cached.isNotEmpty ? cached : null;
      },
    );
  }

  @override
  Future<Result<List<RecentStudy>>> getRecentStudies() {
    return safeOperation(
      tag: AppLogTags.dashboardRepo,
      operation: 'getRecentStudies',
      execute: () async {
        final result = await _dataSource.getRecentStudies();
        await _cache.cacheRecentStudies(result);
        return result;
      },
      fallback: () async {
        final cached = await _cache.getRecentStudies();
        return cached.isNotEmpty ? cached : null;
      },
    );
  }
}
