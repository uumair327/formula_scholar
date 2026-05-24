import 'package:equatable/equatable.dart';

import '../../../onboarding/domain/domain.dart';

enum CurriculumOptionsStatus { initial, loading, loaded, error }

class CurriculumOptionsState extends Equatable {
  const CurriculumOptionsState({
    this.status = CurriculumOptionsStatus.initial,
    this.countries = const [],
    this.states = const [],
    this.boards = const [],
    this.grades = const [],
    this.draftCountryId,
    this.draftStateId,
    this.draftBoardId,
    this.draftGradeId,
    this.errorMessage,
  });

  final CurriculumOptionsStatus status;
  final List<Country> countries;
  final List<StateRegion> states;
  final List<Board> boards;
  final List<Grade> grades;
  
  final String? draftCountryId;
  final String? draftStateId;
  final String? draftBoardId;
  final String? draftGradeId;
  
  final String? errorMessage;

  bool get hasCountries => countries.isNotEmpty;
  bool get hasStates => states.isNotEmpty;
  bool get hasBoards => boards.isNotEmpty;
  bool get hasGrades => grades.isNotEmpty;

  bool get isReadyToApply => draftBoardId != null && draftGradeId != null;

  CurriculumOptionsState copyWith({
    CurriculumOptionsStatus? status,
    List<Country>? countries,
    List<StateRegion>? states,
    List<Board>? boards,
    List<Grade>? grades,
    String? draftCountryId,
    String? draftStateId,
    String? draftBoardId,
    String? draftGradeId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CurriculumOptionsState(
      status: status ?? this.status,
      countries: countries ?? this.countries,
      states: states ?? this.states,
      boards: boards ?? this.boards,
      grades: grades ?? this.grades,
      draftCountryId: draftCountryId ?? this.draftCountryId,
      draftStateId: draftStateId ?? this.draftStateId,
      draftBoardId: draftBoardId ?? this.draftBoardId,
      draftGradeId: draftGradeId ?? this.draftGradeId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        countries,
        states,
        boards,
        grades,
        draftCountryId,
        draftStateId,
        draftBoardId,
        draftGradeId,
        errorMessage,
      ];
}
