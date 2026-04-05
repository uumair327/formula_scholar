import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// State for the Dashboard feature.
///
/// Includes the currently active board/grade selection plus available
/// boards and grades so the filter chips can be rendered dynamically.
class DashboardState extends Equatable {
  final DashboardStatus status;
  final StudyProgress? progress;
  final List<Subject> subjects;
  final List<RecentStudy> recentStudies;
  final List<FormulaVaultItem> vaultItems;
  final String? errorMessage;

  // Board / Grade curriculum context.
  final String selectedBoardName;
  final String selectedGradeName;
  final List<String> availableBoards;
  final List<String> availableGrades;
  final int selectedBoardIndex;
  final int selectedGradeIndex;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.progress,
    this.subjects = const [],
    this.recentStudies = const [],
    this.vaultItems = const [],
    this.errorMessage,
    this.selectedBoardName = 'CBSE',
    this.selectedGradeName = '9th',
    this.availableBoards = const ['CBSE', 'ICSE', 'MSBSHSE'],
    this.availableGrades = const ['8th', '9th', '10th'],
    this.selectedBoardIndex = 0,
    this.selectedGradeIndex = 1,
  });

  /// Dynamic hero badge based on selected board and grade.
  String get heroBadge =>
      '$selectedBoardName Syllabus • Grade $selectedGradeName';

  DashboardState copyWith({
    DashboardStatus? status,
    StudyProgress? progress,
    List<Subject>? subjects,
    List<RecentStudy>? recentStudies,
    List<FormulaVaultItem>? vaultItems,
    String? errorMessage,
    String? selectedBoardName,
    String? selectedGradeName,
    List<String>? availableBoards,
    List<String>? availableGrades,
    int? selectedBoardIndex,
    int? selectedGradeIndex,
  }) {
    return DashboardState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      subjects: subjects ?? this.subjects,
      recentStudies: recentStudies ?? this.recentStudies,
      vaultItems: vaultItems ?? this.vaultItems,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBoardName: selectedBoardName ?? this.selectedBoardName,
      selectedGradeName: selectedGradeName ?? this.selectedGradeName,
      availableBoards: availableBoards ?? this.availableBoards,
      availableGrades: availableGrades ?? this.availableGrades,
      selectedBoardIndex: selectedBoardIndex ?? this.selectedBoardIndex,
      selectedGradeIndex: selectedGradeIndex ?? this.selectedGradeIndex,
    );
  }

  @override
  List<Object?> get props => [
    status,
    progress,
    subjects,
    recentStudies,
    vaultItems,
    errorMessage,
    selectedBoardName,
    selectedGradeName,
    availableBoards,
    availableGrades,
    selectedBoardIndex,
    selectedGradeIndex,
  ];
}
