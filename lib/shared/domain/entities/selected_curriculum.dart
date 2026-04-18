import 'package:equatable/equatable.dart';

/// Represents the user's selected curriculum (board + grade).
class SelectedCurriculum extends Equatable {
  const SelectedCurriculum({
    required this.boardId,
    required this.boardName,
    required this.gradeId,
    required this.gradeLabel,
    required this.gradeNumber,
    this.countryId,
    this.stateId,
    this.countryName,
    this.stateName,
  });
  final String boardId;
  final String boardName;
  final String gradeId;
  final String gradeLabel;
  final int gradeNumber;
  final String? countryId;
  final String? stateId;
  final String? countryName;
  final String? stateName;

  String get displayBadge => '$boardName Syllabus • Grade $gradeLabel';

  String get curriculumKey => '${boardId}_$gradeId';

  @override
  List<Object?> get props => [
    boardId,
    boardName,
    gradeId,
    gradeLabel,
    gradeNumber,
    countryId,
    stateId,
    countryName,
    stateName,
  ];
}
