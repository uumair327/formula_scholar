import 'package:equatable/equatable.dart';

/// Represents the user's selected curriculum (board + grade).
///
/// Decoupled from onboarding domain entities to follow DIP.
/// This is the canonical curriculum representation shared across
/// all features (Dashboard, Chapters, Profile).
class SelectedCurriculum extends Equatable {
  /// Firestore document ID of the board (e.g. 'cbse', 'icse', 'msbshse').
  final String boardId;

  /// Human-readable board name (e.g. 'CBSE', 'ICSE', 'MSBSHSE').
  final String boardName;

  /// Firestore document ID of the grade (e.g. 'class_9', 'class_10').
  final String gradeId;

  /// Human-readable grade label (e.g. 'Class 9', '10th').
  final String gradeLabel;

  /// Grade number for sorting/display (e.g. 9, 10).
  final int gradeNumber;

  const SelectedCurriculum({
    required this.boardId,
    required this.boardName,
    required this.gradeId,
    required this.gradeLabel,
    required this.gradeNumber,
  });

  /// Display string for the hero badge, e.g. "CBSE Syllabus • Grade 9th"
  String get displayBadge => '$boardName Syllabus • Grade $gradeLabel';

  @override
  List<Object?> get props => [boardId, boardName, gradeId, gradeLabel, gradeNumber];
}

/// State for the global curriculum selection.
class CurriculumState extends Equatable {
  final SelectedCurriculum? curriculum;
  final bool isLoading;

  const CurriculumState({
    this.curriculum,
    this.isLoading = false,
  });

  /// Whether a curriculum has been selected.
  bool get hasSelection => curriculum != null;

  /// Convenience getters used by Dashboard and Chapters.
  String get boardId => curriculum?.boardId ?? 'cbse';
  String get boardName => curriculum?.boardName ?? 'CBSE';
  String get gradeId => curriculum?.gradeId ?? 'class_9';
  String get gradeLabel => curriculum?.gradeLabel ?? '9th';
  int get gradeNumber => curriculum?.gradeNumber ?? 9;

  CurriculumState copyWith({
    SelectedCurriculum? curriculum,
    bool? isLoading,
  }) {
    return CurriculumState(
      curriculum: curriculum ?? this.curriculum,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [curriculum, isLoading];
}
