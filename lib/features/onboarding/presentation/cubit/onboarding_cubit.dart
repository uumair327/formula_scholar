import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'onboarding_state.dart';

/// Cubit managing the universal onboarding flow (location -> state -> board -> grade).
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final GetCountriesUseCase _getCountries;
  final GetStatesUseCase _getStates;
  final GetBoardsUseCase _getBoards;
  final GetGradesUseCase _getGrades;

  OnboardingCubit({
    required GetCountriesUseCase getCountries,
    required GetStatesUseCase getStates,
    required GetBoardsUseCase getBoards,
    required GetGradesUseCase getGrades,
  }) : _getCountries = getCountries,
       _getStates = getStates,
       _getBoards = getBoards,
       _getGrades = getGrades,
       super(const OnboardingState());

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
