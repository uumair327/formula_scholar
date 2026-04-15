import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// State for the Dashboard feature.
class DashboardState extends Equatable {
  final DashboardStatus status;
  final StudyProgress? progress;
  final List<Subject> subjects;
  final List<RecentStudy> recentStudies;
  final List<FormulaVaultItem> vaultItems;
  final String? errorMessage;
  final String selectedBoardName;
  final String selectedGradeName;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.progress,
    this.subjects = const [],
    this.recentStudies = const [],
    this.vaultItems = const [],
    this.errorMessage,
    this.selectedBoardName = '',
    this.selectedGradeName = '',
  });

  String get heroBadge {
    if (selectedBoardName.isEmpty || selectedGradeName.isEmpty) {
      return AppStrings.dashboardCurriculumPending;
    }

    return '$selectedBoardName Syllabus • Grade $selectedGradeName';
  }

  String get heroTitle {
    final featured = subjects
        .where((s) => s.isFeatured)
        .cast<Subject?>()
        .firstWhere(
          (s) => s != null,
          orElse: () => subjects.isNotEmpty ? subjects.first : null,
        );

    if (featured == null) {
      return AppStrings.dashboardHeroTitle;
    }

    final headline = featured.subtitle?.trim();
    if (headline != null && headline.isNotEmpty) {
      return AppStrings.dashboardHeroTitleForTopic(headline);
    }

    return AppStrings.dashboardHeroTitleForTopic(featured.name);
  }

  String get heroDescription {
    final mastery = progress?.masteryPercentage ?? 0;
    return AppStrings.dashboardHeroDescriptionWithProgress(mastery.toInt());
  }

  String get vaultDescription {
    final formulaCount = subjects.fold<int>(
      0,
      (sum, subject) => sum + subject.formulaCount,
    );
    return AppStrings.dashboardVaultDescWithCounts(
      formulaCount,
      subjects.length,
    );
  }

  DashboardState copyWith({
    DashboardStatus? status,
    StudyProgress? progress,
    List<Subject>? subjects,
    List<RecentStudy>? recentStudies,
    List<FormulaVaultItem>? vaultItems,
    Object? errorMessage = unset,
    String? selectedBoardName,
    String? selectedGradeName,
  }) {
    return DashboardState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      subjects: subjects ?? this.subjects,
      recentStudies: recentStudies ?? this.recentStudies,
      vaultItems: vaultItems ?? this.vaultItems,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
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
