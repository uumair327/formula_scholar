import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../onboarding/domain/domain.dart';
import 'curriculum_options_state.dart';

class CurriculumOptionsCubit extends Cubit<CurriculumOptionsState>
    with CubitFailureLogger<CurriculumOptionsState> {
  CurriculumOptionsCubit({
    required GetCountriesUseCase getCountries,
    required GetStatesUseCase getStates,
    required GetBoardsUseCase getBoards,
    required GetGradesUseCase getGrades,
    required CurriculumCubit curriculumCubit,
  }) : _getCountries = getCountries,
       _getStates = getStates,
       _getBoards = getBoards,
       _getGrades = getGrades,
       _curriculumCubit = curriculumCubit,
       super(const CurriculumOptionsState()) {
    _curriculumSubscription = _curriculumCubit.stream.distinct().listen((_) {
      Future.microtask(loadOptions);
    });
    Future.microtask(loadOptions);
  }

  final GetCountriesUseCase _getCountries;
  final GetStatesUseCase _getStates;
  final GetBoardsUseCase _getBoards;
  final GetGradesUseCase _getGrades;
  final CurriculumCubit _curriculumCubit;
  late final StreamSubscription<CurriculumState> _curriculumSubscription;

  int _operationId = 0;

  @override
  String get logTag => AppLogTags.dashboardCurriculumOptionsCubit;

  Future<void> loadOptions() async {
    final operationId = ++_operationId;
    final curriculum = _curriculumCubit.state.curriculum;
    if (curriculum == null) {
      if (operationId != _operationId) return;
      emit(
        const CurriculumOptionsState(status: CurriculumOptionsStatus.loaded),
      );
      return;
    }

    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );

    final countriesResult = await _getCountries(limit: 100);
    if (isClosed || operationId != _operationId) return;

    final countries = switch (countriesResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('countries', failure),
    };

    if (countries == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: null,
          errorKey: 'dashboard.curriculum.options.load_failed',
        ),
      );
      return;
    }

    final initialCountryId =
        curriculum.countryId ?? AppStrings.defaultCountryId;
    final draftCountryId =
        _firstWhereOrNull<Country>(
          countries,
          (c) => c.id == initialCountryId,
        )?.id ??
        _firstOrNull(countries)?.id;

    if (draftCountryId == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.loaded,
          countries: countries,
          clearError: true,
        ),
      );
      return;
    }

    await _loadStatesAndDownstream(
      operationId: operationId,
      draftCountryId: draftCountryId,
      countries: countries,
      targetStateId: curriculum.stateId,
      targetBoardId: curriculum.boardId,
      targetGradeId: curriculum.gradeId,
    );
  }

  Future<void> _loadStatesAndDownstream({
    required int operationId,
    required String draftCountryId,
    required List<Country> countries,
    String? targetStateId,
    String? targetBoardId,
    String? targetGradeId,
  }) async {
    final statesResult = await _getStates(draftCountryId, limit: 100);
    if (isClosed || operationId != _operationId) return;

    final states = switch (statesResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('states', failure),
    };

    if (states == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: null,
          errorKey: 'dashboard.curriculum.options.load_failed',
        ),
      );
      return;
    }

    String? draftStateId;
    if (states.isNotEmpty) {
      draftStateId =
          _firstWhereOrNull<StateRegion>(
            states,
            (s) => s.id == targetStateId,
          )?.id ??
          _firstOrNull(states)?.id;
    }

    await _loadBoardsAndDownstream(
      operationId: operationId,
      draftCountryId: draftCountryId,
      draftStateId: draftStateId,
      countries: countries,
      states: states,
      targetBoardId: targetBoardId,
      targetGradeId: targetGradeId,
    );
  }

  Future<void> _loadBoardsAndDownstream({
    required int operationId,
    required String draftCountryId,
    required String? draftStateId,
    required List<Country> countries,
    required List<StateRegion> states,
    String? targetBoardId,
    String? targetGradeId,
  }) async {
    final boardResult = await _getBoards(
      draftCountryId,
      stateId: draftStateId,
      limit: 100,
    );
    if (isClosed || operationId != _operationId) return;

    final boards = switch (boardResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('boards', failure),
    };

    if (boards == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: null,
          errorKey: 'dashboard.curriculum.options.load_failed',
        ),
      );
      return;
    }

    final draftBoardId =
        _firstWhereOrNull<Board>(boards, (b) => b.id == targetBoardId)?.id ??
        _firstOrNull(boards)?.id;

    if (draftBoardId == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.loaded,
          countries: countries,
          states: states,
          boards: boards,
          grades: const [],
          draftCountryId: draftCountryId,
          draftStateId: draftStateId,
          draftBoardId: null,
          draftGradeId: null,
          clearError: true,
        ),
      );
      return;
    }

    await _loadGradesAndDownstream(
      operationId: operationId,
      draftCountryId: draftCountryId,
      draftStateId: draftStateId,
      draftBoardId: draftBoardId,
      countries: countries,
      states: states,
      boards: boards,
      targetGradeId: targetGradeId,
    );
  }

  Future<void> _loadGradesAndDownstream({
    required int operationId,
    required String draftCountryId,
    required String? draftStateId,
    required String draftBoardId,
    required List<Country> countries,
    required List<StateRegion> states,
    required List<Board> boards,
    String? targetGradeId,
  }) async {
    final gradesResult = await _getGrades(draftBoardId, limit: 100);
    if (isClosed || operationId != _operationId) return;

    final grades = switch (gradesResult) {
      Success(:final data) => data.data,
      Error(:final failure) => logFailure('grades', failure),
    };

    if (grades == null) {
      emit(
        state.copyWith(
          status: CurriculumOptionsStatus.error,
          errorMessage: null,
          errorKey: 'dashboard.curriculum.options.load_failed',
        ),
      );
      return;
    }

    final draftGradeId =
        _firstWhereOrNull<Grade>(grades, (g) => g.id == targetGradeId)?.id ??
        _firstOrNull(grades)?.id;

    emit(
      state.copyWith(
        status: CurriculumOptionsStatus.loaded,
        countries: countries,
        states: states,
        boards: boards,
        grades: grades,
        draftCountryId: draftCountryId,
        draftStateId: draftStateId,
        draftBoardId: draftBoardId,
        draftGradeId: draftGradeId,
        clearError: true,
      ),
    );
  }

  Future<void> selectCountry(String countryId) async {
    final operationId = ++_operationId;
    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );
    await _loadStatesAndDownstream(
      operationId: operationId,
      draftCountryId: countryId,
      countries: state.countries,
      targetStateId: null,
      targetBoardId: null,
      targetGradeId: null,
    );
  }

  Future<void> selectState(String stateId) async {
    if (state.draftCountryId == null) return;
    final operationId = ++_operationId;
    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );
    await _loadBoardsAndDownstream(
      operationId: operationId,
      draftCountryId: state.draftCountryId!,
      draftStateId: stateId,
      countries: state.countries,
      states: state.states,
      targetBoardId: null,
      targetGradeId: null,
    );
  }

  Future<void> selectBoard(String boardId) async {
    if (state.draftCountryId == null) return;
    final operationId = ++_operationId;
    emit(
      state.copyWith(status: CurriculumOptionsStatus.loading, clearError: true),
    );
    await _loadGradesAndDownstream(
      operationId: operationId,
      draftCountryId: state.draftCountryId!,
      draftStateId: state.draftStateId,
      draftBoardId: boardId,
      countries: state.countries,
      states: state.states,
      boards: state.boards,
      targetGradeId: null,
    );
  }

  void selectGrade(String gradeId) {
    emit(state.copyWith(draftGradeId: gradeId));
  }

  Future<void> applySelection() async {
    final draftBoardId = state.draftBoardId;
    final draftGradeId = state.draftGradeId;

    if (draftBoardId == null || draftGradeId == null) return;

    final board = _firstWhereOrNull<Board>(
      state.boards,
      (b) => b.id == draftBoardId,
    );
    final grade = _firstWhereOrNull<Grade>(
      state.grades,
      (g) => g.id == draftGradeId,
    );

    if (board == null || grade == null) return;

    final current = _curriculumCubit.state.curriculum;
    final countryName = _firstWhereOrNull<Country>(
      state.countries,
      (c) => c.id == state.draftCountryId,
    )?.name;
    final stateName = _firstWhereOrNull<StateRegion>(
      state.states,
      (s) => s.id == state.draftStateId,
    )?.name;

    await _curriculumCubit.setCurriculum(
      boardId: board.id,
      boardName: board.name,
      gradeId: grade.id,
      gradeLabel: grade.displayLabel,
      gradeNumber: grade.classNumber,
      countryId: state.draftCountryId ?? current?.countryId ?? board.countryId,
      stateId: state.draftStateId ?? current?.stateId ?? board.stateId,
      countryName: countryName ?? current?.countryName,
      stateName: stateName ?? current?.stateName,
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
