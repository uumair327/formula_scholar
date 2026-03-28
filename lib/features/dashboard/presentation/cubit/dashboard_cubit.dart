import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'dashboard_state.dart';

/// Cubit managing the Dashboard screen's state.
///
/// Depends on **use cases** (not repositories directly) following SRP.
/// Uses [Result] pattern matching for typed error handling.
@injectable
class DashboardCubit extends Cubit<DashboardState> {
  final GetStudyProgressUseCase _getStudyProgress;
  final GetSubjectsUseCase _getSubjects;
  final GetRecentStudiesUseCase _getRecentStudies;

  DashboardCubit({
    required GetStudyProgressUseCase getStudyProgress,
    required GetSubjectsUseCase getSubjects,
    required GetRecentStudiesUseCase getRecentStudies,
  })  : _getStudyProgress = getStudyProgress,
        _getSubjects = getSubjects,
        _getRecentStudies = getRecentStudies,
        super(const DashboardState());

  /// Loads all dashboard data in parallel.
  Future<void> loadDashboard() async {
    AppLogger.info('Loading dashboard data', tag: AppLogTags.dashboardCubit);
    emit(state.copyWith(status: DashboardStatus.loading));

    final (progressResult, subjectsResult, studiesResult) = await (
      _getStudyProgress(),
      _getSubjects(),
      _getRecentStudies(),
    ).wait;

    // Pattern match on each result for typed error handling.
    final progress = switch (progressResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('study progress', failure),
    };

    final subjects = switch (subjectsResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('subjects', failure),
    };

    final recentStudies = switch (studiesResult) {
      Success(:final data) => data,
      Error(:final failure) => _logFailure('recent studies', failure),
    };

    if (progress != null && subjects != null && recentStudies != null) {
      AppLogger.info(
        'Dashboard loaded: ${subjects.length} subjects',
        tag: AppLogTags.dashboardCubit,
      );
      emit(state.copyWith(
        status: DashboardStatus.loaded,
        progress: progress,
        subjects: subjects,
        recentStudies: recentStudies,
      ));
    } else {
      emit(state.copyWith(
        status: DashboardStatus.error,
        errorMessage: AppStrings.failedToLoadDashboard,
      ));
    }
  }

  /// Logs a failure and returns null to indicate the operation failed.
  Null _logFailure(String operation, Failure failure) {
    AppLogger.error(
      'Failed to load $operation: ${failure.message}',
      tag: AppLogTags.dashboardCubit,
      error: failure.originalError,
      stackTrace: failure.stackTrace,
    );
    return null;
  }
}
