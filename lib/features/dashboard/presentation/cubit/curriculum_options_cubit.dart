import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../onboarding/domain/domain.dart';
import 'curriculum_options_state.dart';

class CurriculumOptionsCubit extends Cubit<CurriculumOptionsState>
    with CubitFailureLogger<CurriculumOptionsState> {
  CurriculumOptionsCubit({
    required GetBoardsUseCase getBoards,
    required GetGradesUseCase getGrades,
    required CurriculumCubit curriculumCubit,
  }) : _getBoards = getBoards,
       _getGrades = getGrades,
       _curriculumCubit = curriculumCubit,
       super(const CurriculumOptionsState()) {
    _curriculumSubscription = _curriculumCubit.stream.distinct().listen((_) {
      Future.microtask(loadOptions);
    });
    Future.microtask(loadOptions);
  }

  final GetBoardsUseCase _getBoards;
  final GetGradesUseCase _getGrades;
  final CurriculumCubit _curriculumCubit;
  late final StreamSubscription<CurriculumState> _curriculumSubscription;

  @override
  String get logTag => AppLogTags.dashboardCurriculumOptionsCubit;

  Future<void> loadOptions() async {
    final curriculum = _curriculumCubit.state.curriculum;
    if (curriculum == null) {
      emit(
        const CurriculumOptionsState(
          status: CurriculumOptionsStatus.loaded,
          boards: [],
          grades: [],
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );

    final countryId = curriculum.countryId ?? AppStrings.defaultCountryId;
    final boardResult = await _getBoards(
      countryId,
      stateId: curriculum.stateId,
      limit: 100,
    );

    if (isClosed) return;

    final boards = switch (boardResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('boards', failure),
    };

    if (boards == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: AppStrings.dashboardCurriculumOptionsLoadFailed,
        ),
      );
      return;
    }

    final activeBoard = _firstWhereOrNull<Board>(
      boards,
      (board) => board.id == curriculum.boardId,
    );

    final boardForGrades = activeBoard ?? _firstOrNull(boards);

    if (boardForGrades == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.loaded,
          boards: boards,
          grades: const [],
          clearError: true,
        ),
      );
      return;
    }

    final gradesResult = await _getGrades(boardForGrades.id, limit: 100);
    final grades = switch (gradesResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('grades', failure),
    };

    if (grades == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          boards: boards,
          grades: const [],
          errorMessage: AppStrings.dashboardCurriculumOptionsLoadFailed,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: CurriculumOptionsStatus.loaded,
        boards: boards,
        grades: grades,
        clearError: true,
      ),
    );

    final hasCurrentBoard = activeBoard != null;
    final hasCurrentGrade = grades.any(
      (grade) => grade.id == curriculum.gradeId,
    );
    if (!hasCurrentBoard || !hasCurrentGrade) {
      final fallbackGrade = _firstOrNull(grades);
      if (fallbackGrade != null) {
        await _applySelection(boardForGrades, fallbackGrade);
      }
    }
  }

  Future<void> selectBoard(Board board) async {
    final curriculum = _curriculumCubit.state.curriculum;
    if (curriculum == null) {
      return;
    }

    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );

    final gradesResult = await _getGrades(board.id, limit: 100);
    if (isClosed) return;

    final grades = switch (gradesResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('grades for board switch', failure),
    };

    if (grades == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: AppStrings.dashboardCurriculumOptionsLoadFailed,
        ),
      );
      return;
    }

    if (grades.isEmpty) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.loaded,
          grades: const [],
          clearError: true,
        ),
      );
      return;
    }

    final activeGrade = _firstWhereOrNull<Grade>(
      grades,
      (grade) => grade.id == curriculum.gradeId,
    );
    final targetGrade = activeGrade ?? grades.first;

    emit(
      state.copyWith(
        status: CurriculumOptionsStatus.loaded,
        grades: grades,
        clearError: true,
      ),
    );

    await _applySelection(board, targetGrade);
  }

  Future<void> selectGrade(Grade grade) async {
    final curriculum = _curriculumCubit.state.curriculum;
    if (curriculum == null) {
      return;
    }

    final board = _firstWhereOrNull<Board>(
      state.boards,
      (item) => item.id == curriculum.boardId,
    );
    if (board == null) {
      return;
    }

    await _applySelection(board, grade);
  }

  Future<void> _applySelection(Board board, Grade grade) async {
    final current = _curriculumCubit.state.curriculum;
    if (current == null) {
      return;
    }

    final sameSelection =
        current.boardId == board.id && current.gradeId == grade.id;
    if (sameSelection) {
      return;
    }

    await _curriculumCubit.setCurriculum(
      boardId: board.id,
      boardName: board.name,
      gradeId: grade.id,
      gradeLabel: grade.displayLabel,
      gradeNumber: grade.classNumber,
      countryId: current.countryId ?? board.countryId,
      stateId: current.stateId ?? board.stateId,
      countryName: current.countryName,
      stateName: current.stateName,
    );
  }

  T? _firstOrNull<T>(List<T> items) {
    if (items.isEmpty) {
      return null;
    }

    return items.first;
  }

  T? _firstWhereOrNull<T>(List<T> items, bool Function(T item) predicate) {
    for (final item in items) {
      if (predicate(item)) {
        return item;
      }
    }

    return null;
  }

  @override
  Future<void> close() async {
    await _curriculumSubscription.cancel();
    return super.close();
  }
}
