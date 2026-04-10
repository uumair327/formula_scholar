import 'package:equatable/equatable.dart';

import '../../domain/domain.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// State for the Dashboard feature.
///
/// The active board/grade come from the global [CurriculumCubit]
/// and are stored here as display strings for the hero badge.
class DashboardState extends Equatable {
  final DashboardStatus status;
  final StudyProgress? progress;
  final List<Subject> subjects;
  final List<RecentStudy> recentStudies;
  final List<FormulaVaultItem> vaultItems;
  final String? errorMessage;

  // Board / Grade display values (synced from CurriculumCubit).
  final String selectedBoardName;
  final String selectedGradeName;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.progress,
    this.subjects = const [],
    this.recentStudies = const [],
    this.vaultItems = const [],
    this.errorMessage,
    this.selectedBoardName = 'CBSE',
    this.selectedGradeName = '9th',
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
  ];
}
