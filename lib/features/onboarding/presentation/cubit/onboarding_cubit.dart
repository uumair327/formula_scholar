import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/domain/domain.dart';
import '../../domain/domain.dart';
import '../../../profile/domain/domain.dart';
import 'onboarding_state.dart';

/// Cubit managing the universal onboarding flow (location -> state -> board -> grade).
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit({
    required GetCountriesUseCase getCountries,
    required GetStatesUseCase getStates,
    required GetBoardsUseCase getBoards,
    required GetGradesUseCase getGrades,
    required SaveCurriculumUseCase saveCurriculum,
    required UpdateStudyGoalUseCase updateStudyGoal,
  }) : _getCountries = getCountries,
       _getStates = getStates,
       _getBoards = getBoards,
       _getGrades = getGrades,
       _saveCurriculum = saveCurriculum,
       _updateStudyGoal = updateStudyGoal,
        super(const OnboardingState()) {
    Future.microtask(loadCountries);
  }
  final GetCountriesUseCase _getCountries;
  final GetStatesUseCase _getStates;
  final GetBoardsUseCase _getBoards;
  final GetGradesUseCase _getGrades;
  final SaveCurriculumUseCase _saveCurriculum;
  final UpdateStudyGoalUseCase _updateStudyGoal;

  /// Loads available countries for Step 1.
  Future<void> loadCountries() async {
    AppLogger.info('Loading countries', tag: AppLogTags.onboardingCubit);
    emit(state.copyWith(status: OnboardingStatus.loading));

    final result = await _getCountries();
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: OnboardingStatus.loaded,
            countries: data.data,
            step: OnboardingStep.locationSelection,
          ),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: OnboardingStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Selects a country. If it has states, we load states.
  /// If it doesn't, we can skip directly to Boards. For now, we assume states selection applies.
  Future<void> selectCountry(Country country) async {
    AppLogger.info(
      'Country selected: ${country.name}',
      tag: AppLogTags.onboardingCubit,
    );
    emit(
      state.copyWith(
        selectedCountry: country,
        selectedState: null, // Clear past selections
        selectedBoard: null,
        selectedGrade: null,
        status: OnboardingStatus.loading,
      ),
    );

    // Try finding states
    final result = await _getStates(country.id);
    switch (result) {
      case Success(:final data):
        if (data.data.isNotEmpty) {
          emit(
            state.copyWith(
              status: OnboardingStatus.loaded,
              states: data.data,
              // Not bumping step in state yet, the UI will handle navigation,
              // or we can bump the step to stateSelection.
              step: OnboardingStep.locationSelection,
            ),
          );
        } else {
          // Skip state selection if empty
          emit(state.copyWith(status: OnboardingStatus.loaded));
        }
      case Error(:final failure):
        emit(
          state.copyWith(
            status: OnboardingStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Sets state manually (from a search field or suggestion).
  void selectStateRegion(StateRegion stateRegion) {
    AppLogger.info(
      'State selected: ${stateRegion.name}',
      tag: AppLogTags.onboardingCubit,
    );
    emit(state.copyWith(selectedState: stateRegion));
  }

  /// Triggered when user confirms step 1
  Future<void> confirmLocation() async {
    emit(
      state.copyWith(
        status: OnboardingStatus.loading,
        step: OnboardingStep.boardSelection,
      ),
    );

    final countryId = state.selectedCountry?.id ?? 'IN';
    final stateId = state.selectedState?.id;

    final result = await _getBoards(countryId, stateId: stateId);
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(status: OnboardingStatus.loaded, boards: data.data),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: OnboardingStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Selects a board and transitions to grade selection.
  Future<void> selectBoard(Board board) async {
    AppLogger.info(
      'Board selected: ${board.name}',
      tag: AppLogTags.onboardingCubit,
    );
    emit(
      state.copyWith(
        selectedBoard: board,
        selectedGrade: null,
        step: OnboardingStep.gradeSelection,
        status: OnboardingStatus.loading,
      ),
    );

    final result = await _getGrades(board.id);
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(status: OnboardingStatus.loaded, grades: data.data),
        );
      case Error(:final failure):
        emit(
          state.copyWith(
            status: OnboardingStatus.error,
            errorMessage: failure.message,
          ),
        );
    }
  }

  /// Selects a grade — onboarding is now complete.
  void selectGrade(Grade grade) {
    AppLogger.info(
      'Grade selected: ${grade.label}',
      tag: AppLogTags.onboardingCubit,
    );
    emit(state.copyWith(selectedGrade: grade));
  }

  /// Persists the selected curriculum and study goal, marks onboarding as complete.
  Future<SelectedCurriculum?> completeOnboarding(String studyGoalId) async {
    final board = state.selectedBoard;
    final grade = state.selectedGrade;

    if (board == null || grade == null) {
      AppLogger.warning(
        'Cannot complete onboarding without board and grade selection',
        tag: AppLogTags.onboardingCubit,
      );
      return null;
    }

    final curriculum = SelectedCurriculum(
      boardId: board.id,
      boardName: board.name,
      gradeId: grade.id,
      gradeLabel: grade.displayLabel,
      gradeNumber: grade.classNumber,
      countryId: state.selectedCountry?.id,
      stateId: state.selectedState?.id,
      countryName: state.selectedCountry?.name,
      stateName: state.selectedState?.name,
    );

    AppLogger.info(
      'Completing onboarding for board=${board.name}, grade=${grade.displayLabel}, goal=$studyGoalId',
      tag: AppLogTags.onboardingCubit,
    );

    try {
      await _saveCurriculum(curriculum);
      final goalResult = await _updateStudyGoal(studyGoalId);
      if (goalResult is Error) {
        AppLogger.warning(
          'Failed to save study goal during onboarding.',
          tag: AppLogTags.onboardingCubit,
        );
      }
      return curriculum;
    } catch (e, st) {
      AppLogger.error(
        'Failed to persist curriculum during onboarding completion',
        tag: AppLogTags.onboardingCubit,
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Navigation helpers
  void goBackToLocationSelection() {
    emit(
      state.copyWith(
        step: OnboardingStep.locationSelection,
        status: OnboardingStatus.loaded,
      ),
    );
  }

  void goBackToBoards() {
    emit(
      state.copyWith(
        step: OnboardingStep.boardSelection,
        status: OnboardingStatus.loaded,
      ),
    );
  }
}
