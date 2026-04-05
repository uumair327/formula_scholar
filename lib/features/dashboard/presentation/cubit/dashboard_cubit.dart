import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'dashboard_state.dart';

/// Cubit managing the Dashboard screen's state.
///
/// Depends on **use cases** (not repositories directly) following SRP.
/// Uses [Result] pattern matching for typed error handling.
/// Uses [CubitFailureLogger] mixin to eliminate boilerplate.
@injectable
class DashboardCubit extends Cubit<DashboardState>
    with CubitFailureLogger<DashboardState> {
  final GetStudyProgressUseCase _getStudyProgress;
  final GetSubjectsUseCase _getSubjects;
  final GetRecentStudiesUseCase _getRecentStudies;

  @override
  String get logTag => AppLogTags.dashboardCubit;

  DashboardCubit({
    required GetStudyProgressUseCase getStudyProgress,
    required GetSubjectsUseCase getSubjects,
    required GetRecentStudiesUseCase getRecentStudies,
  }) : _getStudyProgress = getStudyProgress,
       _getSubjects = getSubjects,
       _getRecentStudies = getRecentStudies,
       super(const DashboardState());

  /// Loads all dashboard data in parallel.
  Future<void> loadDashboard() async {
    AppLogger.info('Loading dashboard data', tag: AppLogTags.dashboardCubit);
    emit(state.copyWith(status: DashboardStatus.loading));

    final boardName = state.availableBoards.isNotEmpty
        ? state.availableBoards[state.selectedBoardIndex]
        : 'CBSE';
    final gradeName = state.availableGrades.isNotEmpty
        ? state.availableGrades[state.selectedGradeIndex]
        : '9th';

    final boardId = _mapBoard(boardName);
    final gradeId = _mapGrade(gradeName);

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

  /// Switches the active board in the filter bar.
  void switchBoard(int index) {
    final boards = state.availableBoards;
    if (index < 0 || index >= boards.length) return;

    AppLogger.info(
      'Switching board to: ${boards[index]}',
      tag: AppLogTags.dashboardCubit,
    );

    emit(
      state.copyWith(
        selectedBoardIndex: index,
        selectedBoardName: boards[index],
      ),
    );
    loadDashboard();
  }

  /// Switches the active grade in the filter bar.
  void switchGrade(int index) {
    final grades = state.availableGrades;
    if (index < 0 || index >= grades.length) return;

    AppLogger.info(
      'Switching grade to: ${grades[index]}',
      tag: AppLogTags.dashboardCubit,
    );

    emit(
      state.copyWith(
        selectedGradeIndex: index,
        selectedGradeName: grades[index],
      ),
    );
    loadDashboard();
  }

  String _mapBoard(String boardName) {
    switch (boardName.toLowerCase()) {
      case 'cbse':
        return 'cbse';
      case 'icse':
        return 'icse';
      case 'state':
      case 'msbshse':
        return 'msbshse';
      default:
        return 'cbse';
    }
  }

  String _mapGrade(String gradeName) {
    switch (gradeName.toLowerCase()) {
      case '8th':
        return 'class_8';
      case '9th':
        return 'class_9';
      case '10th':
        return 'class_10';
      case '11th':
        return 'class_11';
      case '12th':
        return 'class_12';
      default:
        return 'class_9';
    }
  }
}
