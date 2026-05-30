import 'package:equatable/equatable.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

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
    this.errorKey,
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
  final String? errorKey;
  final String selectedBoardName;
  final String selectedGradeName;
  final int currentBannerIndex;
  final int currentAnnouncementIndex;
  final List<String> dismissedAnnouncementIds;
  final Map<String, String> localizedContent;

  // UI presentation labels should be handled by the Presentation layer
  // using context.l10n and localizedContent.

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
    String? errorKey,
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
      errorKey: errorKey ?? this.errorKey,
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
    errorKey,
    selectedBoardName,
    selectedGradeName,
    currentBannerIndex,
    currentAnnouncementIndex,
    dismissedAnnouncementIds,
    localizedContent,
  ];
}
