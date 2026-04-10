import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'dashboard_state.dart';

/// Cubit managing the Dashboard screen's state.
///
/// Depends on **use cases** (not repositories directly) following SRP.
/// Uses [Result] pattern matching for typed error handling.
/// Uses [CubitFailureLogger] mixin to eliminate boilerplate.
///
/// Reads the user's selected board/grade from the global
/// [CurriculumCubit] to ensure curriculum synchronization.
@injectable
class DashboardCubit extends Cubit<DashboardState>
    with CubitFailureLogger<DashboardState> {
  final GetStudyProgressUseCase _getStudyProgress;
  final GetSubjectsUseCase _getSubjects;
  final GetRecentStudiesUseCase _getRecentStudies;
  final CurriculumCubit _curriculumCubit;

  @override
  String get logTag => AppLogTags.dashboardCubit;

  DashboardCubit({
    required GetStudyProgressUseCase getStudyProgress,
    required GetSubjectsUseCase getSubjects,
    required GetRecentStudiesUseCase getRecentStudies,
    required CurriculumCubit curriculumCubit,
  }) : _getStudyProgress = getStudyProgress,
       _getSubjects = getSubjects,
       _getRecentStudies = getRecentStudies,
       _curriculumCubit = curriculumCubit,
       super(const DashboardState());

  /// Loads all dashboard data in parallel.
  ///
  /// Reads board/grade from the global [CurriculumCubit] to ensure
  /// curriculum sync across the app.
  Future<void> loadDashboard() async {
    AppLogger.info('Loading dashboard data', tag: AppLogTags.dashboardCubit);
    emit(state.copyWith(status: DashboardStatus.loading));

    // Read the user's curriculum from the global cubit.
    final curriculum = _curriculumCubit.state;
    final boardId = curriculum.boardId;
    final gradeId = curriculum.gradeId;
    final boardName = curriculum.boardName;
    final gradeLabel = curriculum.gradeLabel;

    AppLogger.info(
      'Dashboard using curriculum: board=$boardName ($boardId), grade=$gradeLabel ($gradeId)',
      tag: AppLogTags.dashboardCubit,
    );

    final (progressResult, subjectsResult, studiesResult) = await (
      _getStudyProgress(),
      _getSubjects(boardId, gradeId),
      _getRecentStudies(),
    ).wait;

    // Pattern match on each result for typed error handling.
    final progress = switch (progressResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('study progress', failure),
    };

    final subjects = switch (subjectsResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('subjects', failure),
    };

    final recentStudies = switch (studiesResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('recent studies', failure),
    };

    if (progress != null && subjects != null && recentStudies != null) {
      AppLogger.info(
        'Dashboard loaded: ${subjects.length} subjects',
        tag: AppLogTags.dashboardCubit,
      );

      // Build vault items from subjects — data-driven, no hardcoding.
      final vaultItems = subjects
          .map(
            (s) => FormulaVaultItem(
              id: s.id,
              label: s.category.toUpperCase(),
              title: s.name.split(' & ').first, // Short label
            ),
          )
          .toList();

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          progress: progress,
          subjects: subjects,
          recentStudies: recentStudies,
          vaultItems: vaultItems,
          selectedBoardName: boardName,
          selectedGradeName: gradeLabel,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: AppStrings.failedToLoadDashboard,
        ),
      );
    }
  }
}
