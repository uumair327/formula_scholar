import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

const Object _unset = Object();

enum OnboardingStep {
  locationSelection,
  stateSelection,
  boardSelection,
  gradeSelection,
}

enum OnboardingStatus { initial, loading, loaded, error }

/// State for the onboarding flow.
class OnboardingState extends Equatable {

  const OnboardingState({
    this.step = OnboardingStep.locationSelection,
    this.status = OnboardingStatus.initial,
    this.countries = const [],
    this.states = const [],
    this.boards = const [],
    this.grades = const [],
    this.selectedCountry,
    this.selectedState,
    this.selectedBoard,
    this.selectedGrade,
    this.errorMessage,
  });
  final OnboardingStep step;
  final OnboardingStatus status;

  // Data
  final List<Country> countries;
  final List<StateRegion> states;
  final List<Board> boards;
  final List<Grade> grades;

  // Selections
  final Country? selectedCountry;
  final StateRegion? selectedState;
  final Board? selectedBoard;
  final Grade? selectedGrade;

  final String? errorMessage;

  bool get isComplete =>
      selectedCountry != null && selectedBoard != null && selectedGrade != null;

  int get currentStepNumber {
    switch (step) {
      case OnboardingStep.locationSelection:
        return 1;
      case OnboardingStep.stateSelection:
        return 2;
      case OnboardingStep.boardSelection:
        return 3;
      case OnboardingStep.gradeSelection:
        return 4;
    }
  }

  int get totalSteps => 4;

  OnboardingState copyWith({
    OnboardingStep? step,
    OnboardingStatus? status,
    List<Country>? countries,
    List<StateRegion>? states,
    List<Board>? boards,
    List<Grade>? grades,
    Object? selectedCountry = _unset,
    Object? selectedState = _unset,
    Object? selectedBoard = _unset,
    Object? selectedGrade = _unset,
    Object? errorMessage = _unset,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      status: status ?? this.status,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      boards: boards ?? this.boards,
      grades: grades ?? this.grades,
      selectedCountry: identical(selectedCountry, _unset)
          ? this.selectedCountry
          : selectedCountry as Country?,
      selectedState: identical(selectedState, _unset)
          ? this.selectedState
          : selectedState as StateRegion?,
      selectedBoard: identical(selectedBoard, _unset)
          ? this.selectedBoard
          : selectedBoard as Board?,
      selectedGrade: identical(selectedGrade, _unset)
          ? this.selectedGrade
          : selectedGrade as Grade?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    countries,
    states,
    boards,
    grades,
    selectedCountry,
    selectedState,
    selectedBoard,
    selectedGrade,
    errorMessage,
  ];
}
