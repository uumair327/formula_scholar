import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

enum DashboardStatus { initial, loading, loaded, error }

/// State for the Dashboard feature.
class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.progress,
    this.subjects = const [],
    this.recentStudies = const [],
    this.vaultItems = const [],
    this.banners = const [],
    this.announcements = const [],
    this.weakAreas = const [],
    this.errorMessage,
    this.selectedBoardName = '',
    this.selectedGradeName = '',
    this.currentBannerIndex = 0,
    this.currentAnnouncementIndex = 0,
    this.dismissedAnnouncementIds = const [],
    this.localizedContent = const {},
  });
  final DashboardStatus status;
  final StudyProgress? progress;
  final List<Subject> subjects;
  final List<RecentStudy> recentStudies;
  final List<FormulaVaultItem> vaultItems;
  final List<CarouselItem> banners;
  final List<AppAnnouncement> announcements;
  final List<WeakArea> weakAreas;
  final String? errorMessage;
  final String selectedBoardName;
  final String selectedGradeName;
  final int currentBannerIndex;
  final int currentAnnouncementIndex;
  final List<String> dismissedAnnouncementIds;
  final Map<String, String> localizedContent;

  String _localizedValue(String key, String fallback) {
    final value = localizedContent[key]?.trim();
    if (value == null || value.isEmpty) {
      return fallback;
    }
    return value;
  }

  String get heroBadge {
    final localizedBadge = _localizedValue('dashboard.hero.badge', '');
    if (localizedBadge.isNotEmpty) {
      return localizedBadge;
    }

    if (selectedBoardName.isEmpty || selectedGradeName.isEmpty) {
      return AppStrings.dashboardCurriculumPending;
    }

    return '$selectedBoardName Syllabus • Grade $selectedGradeName';
  }

  String get heroTitle {
    final localizedTitle = _localizedValue('dashboard.hero.title', '');
    if (localizedTitle.isNotEmpty) {
      return localizedTitle;
    }

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
    final template = _localizedValue('dashboard.hero.description', '');
    if (template.isNotEmpty) {
      return template.replaceAll('{progress}', mastery.toInt().toString());
    }

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

  String get heroResumeLabel {
    return _localizedValue(
      'dashboard.hero.resume',
      AppStrings.dashboardResumeLesson,
    );
  }

  String get heroSemanticsLabel {
    return _localizedValue(
      'dashboard.hero.resumeSemantic',
      AppStrings.resumeLearning,
    );
  }

  String get quickActionsTitle {
    return _localizedValue(
      'dashboard.quickActions.title',
      AppStrings.exploreTools,
    );
  }

  String get liveLabel {
    return _localizedValue('dashboard.live', AppStrings.dashboardLive);
  }

  String get boardReadyQuizTitle {
    return _localizedValue(
      'dashboard.boardReadyQuiz',
      AppStrings.dashboardBoardReadyQuiz,
    );
  }

  String get boardReadyQuizDescription {
    return _localizedValue(
      'dashboard.quizDescription',
      AppStrings.dashboardQuizDesc,
    );
  }

  String get startNowLabel {
    return _localizedValue('dashboard.startNow', AppStrings.startNow);
  }

  String get startQuizLabel {
    return _localizedValue('dashboard.startQuiz', AppStrings.startQuiz);
  }

  String get academicViewAllLabel {
    return _localizedValue('dashboard.academic.viewAll', AppStrings.viewAll);
  }

  String get vaultDescriptionOverride {
    return _localizedValue(
      'dashboard.vault.description',
      AppStrings.dashboardVaultDesc,
    );
  }

  String get studyPlannerLabel {
    return _localizedValue(
      'dashboard.quickActions.studyPlanner',
      AppStrings.studyPlanner,
    );
  }

  String get analyticsLabel {
    return _localizedValue(
      'dashboard.quickActions.analytics',
      AppStrings.viewAnalytics,
    );
  }

  String get flashcardsLabel {
    return _localizedValue(
      'dashboard.quickActions.flashcards',
      AppStrings.flashcards,
    );
  }

  String get continueStudyingLabel {
    return _localizedValue(
      'dashboard.continueStudying',
      AppStrings.continueStudying,
    );
  }

  String get noRecentTitle {
    return _localizedValue(
      'dashboard.noRecent.title',
      AppStrings.dashboardNoRecentTitle,
    );
  }

  String get noRecentDescription {
    return _localizedValue(
      'dashboard.noRecent.description',
      AppStrings.dashboardNoRecentDescription,
    );
  }

  String get openChaptersLabel {
    return _localizedValue(
      'dashboard.openChapters',
      AppStrings.dashboardOpenChapters,
    );
  }

  DashboardState copyWith({
    DashboardStatus? status,
    StudyProgress? progress,
    List<Subject>? subjects,
    List<RecentStudy>? recentStudies,
    List<FormulaVaultItem>? vaultItems,
    List<CarouselItem>? banners,
    List<AppAnnouncement>? announcements,
    List<WeakArea>? weakAreas,
    Object? errorMessage = unset,
    String? selectedBoardName,
    String? selectedGradeName,
    int? currentBannerIndex,
    int? currentAnnouncementIndex,
    List<String>? dismissedAnnouncementIds,
    Map<String, String>? localizedContent,
  }) {
    return DashboardState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      subjects: subjects ?? this.subjects,
      recentStudies: recentStudies ?? this.recentStudies,
      vaultItems: vaultItems ?? this.vaultItems,
      banners: banners ?? this.banners,
      announcements: announcements ?? this.announcements,
      weakAreas: weakAreas ?? this.weakAreas,
      errorMessage: identical(errorMessage, unset)
          ? this.errorMessage
          : errorMessage as String?,
      selectedBoardName: selectedBoardName ?? this.selectedBoardName,
      selectedGradeName: selectedGradeName ?? this.selectedGradeName,
      currentBannerIndex: currentBannerIndex ?? this.currentBannerIndex,
      currentAnnouncementIndex:
          currentAnnouncementIndex ?? this.currentAnnouncementIndex,
      dismissedAnnouncementIds:
          dismissedAnnouncementIds ?? this.dismissedAnnouncementIds,
      localizedContent: localizedContent ?? this.localizedContent,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    status,
    progress,
    subjects,
    recentStudies,
    vaultItems,
    banners,
    announcements,
    weakAreas,
    errorMessage,
    selectedBoardName,
    selectedGradeName,
    currentBannerIndex,
    currentAnnouncementIndex,
    dismissedAnnouncementIds,
    localizedContent,
  ];
}
