import 'package:equatable/equatable.dart';

import '../../../onboarding/domain/domain.dart';

enum CurriculumOptionsStatus { initial, loading, loaded, error }

class CurriculumOptionsState extends Equatable {
  const CurriculumOptionsState({
    this.status = CurriculumOptionsStatus.initial,
    this.boards = const [],
    this.grades = const [],
    this.errorMessage,
  });

  final CurriculumOptionsStatus status;
  final List<Board> boards;
  final List<Grade> grades;
  final String? errorMessage;

  bool get hasBoards => boards.isNotEmpty;
  bool get hasGrades => grades.isNotEmpty;

  CurriculumOptionsState copyWith({
    CurriculumOptionsStatus? status,
    List<Board>? boards,
    List<Grade>? grades,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CurriculumOptionsState(
      status: status ?? this.status,
      boards: boards ?? this.boards,
      grades: grades ?? this.grades,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, boards, grades, errorMessage];
}
