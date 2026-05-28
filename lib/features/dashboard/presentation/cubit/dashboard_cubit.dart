import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'dashboard_state.dart';

@injectable
class DashboardCubit extends Cubit<DashboardState>
    with CubitFailureLogger<DashboardState> {
  DashboardCubit({
    required GetStudyProgressUseCase getStudyProgress,
    required GetSubjectsUseCase getSubjects,
    required GetRecentStudiesUseCase getRecentStudies,
    required GetBannersUseCase getBanners,
    required GetAnnouncementsUseCase getAnnouncements,
    required GetWeakAreasUseCase getWeakAreas,
    required CurriculumCubit curriculumCubit,
    required ActivityRefreshCubit activityRefreshCubit,
  }) : _getStudyProgress = getStudyProgress,
       _getSubjects = getSubjects,
       _getRecentStudies = getRecentStudies,
       _getBanners = getBanners,
       _getAnnouncements = getAnnouncements,
       _getWeakAreas = getWeakAreas,
       _curriculumCubit = curriculumCubit,
       _activityRefreshCubit = activityRefreshCubit,
       super(const DashboardState()) {
    _watchCurriculumChanges();
    _watchActivityRefreshSignals();
    _onCurriculumStateChanged(_curriculumCubit.state);
  }
  final GetStudyProgressUseCase _getStudyProgress;
  final GetSubjectsUseCase _getSubjects;
  final GetRecentStudiesUseCase _getRecentStudies;
  final GetBannersUseCase _getBanners;
  final GetAnnouncementsUseCase _getAnnouncements;
  final GetWeakAreasUseCase _getWeakAreas;
  final CurriculumCubit _curriculumCubit;
  final ActivityRefreshCubit _activityRefreshCubit;
  String _contentLocaleCode = AppLocales.defaultContentLocaleCode;
  late final StreamSubscription<CurriculumState> _curriculumSubscription;
  late final StreamSubscription<int> _activityRefreshSubscription;

  @override
  String get logTag => AppLogTags.dashboardCubit;

  @override
  Future<void> close() async {
    await _curriculumSubscription.cancel();
    await _activityRefreshSubscription.cancel();
    return super.close();
  }

  void _watchCurriculumChanges() {
    _curriculumSubscription = _curriculumCubit.stream.distinct().listen(
      _onCurriculumStateChanged,
    );
  }

  void _onCurriculumStateChanged(CurriculumState curriculumState) {
    if (!curriculumState.isLoading) {
      Future.microtask(loadDashboard);
    }
  }

  void _watchActivityRefreshSignals() {
    _activityRefreshSubscription = _activityRefreshCubit.stream.listen((_) {
      if (state.status == DashboardStatus.loading) {
        return;
      }

      Future.microtask(loadDashboard);
    });
  }

  void setContentLocaleCode(String localeCode) {
    final normalized = AppLocales.normalizeContentLocaleCode(localeCode);
    if (_contentLocaleCode == normalized) {
      return;
    }

    _contentLocaleCode = normalized;
    AppLogger.info(
      'Dashboard content locale set to $_contentLocaleCode',
      tag: AppLogTags.dashboardCubit,
    );
  }

  Future<void> loadDashboard() async {
    AppLogger.info('Loading dashboard data', tag: AppLogTags.dashboardCubit);
    emit(state.copyWith(status: DashboardStatus.loading));

    final curriculumState = _curriculumCubit.state;
    if (curriculumState.isLoading) {
      AppLogger.info(
        'Curriculum still syncing, dashboard load deferred',
        tag: AppLogTags.dashboardCubit,
      );
      return;
    }

    final curriculum = curriculumState.curriculum;
    if (curriculum == null) {
      AppLogger.warning(
        'Dashboard load blocked because curriculum is missing',
        tag: AppLogTags.dashboardCubit,
      );
      emit(
        state.copyWith(
          status: DashboardStatus.error,
          errorMessage: AppStrings.dashboardCurriculumRequired,
          subjects: const [],
          recentStudies: const [],
          vaultItems: const [],
          selectedBoardName: '',
          selectedGradeName: '',
        ),
      );
      return;
    }

    AppLogger.info(
      'Dashboard using curriculum: board=${curriculum.boardName} (${curriculum.boardId}), grade=${curriculum.gradeLabel} (${curriculum.gradeId})',
      tag: AppLogTags.dashboardCubit,
    );

    final (
      progressResult,
      subjectsResult,
      studiesResult,
      bannersResult,
      announcementsResult,
      weakAreasResult,
      localizedContentResult,
    ) = await (
      _getStudyProgress(),
      _getSubjects(curriculum.boardId, curriculum.gradeId),
      _getRecentStudies(),
      _getBanners(),
      _getAnnouncements(),
      _getWeakAreas(),
      getIt<LocalizedContentRepositoryPort>().getContentBundle(
        _contentLocaleCode,
      ),
    ).wait;

    if (isClosed) return;

    final progress = switch (progressResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('study progress', failure),
    };

    final subjects = switch (subjectsResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('subjects', failure),
    };

    final recentStudies = switch (studiesResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('recent studies', failure),
    };

    final banners = switch (bannersResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('banners', failure),
    };

    final announcements = switch (announcementsResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('announcements', failure),
    };

    final weakAreas = switch (weakAreasResult) {
      Success(:final data) => data,
      Error(:final failure) => logFailure('weak areas', failure),
    };

    final localizedContent = switch (localizedContentResult) {
      Success(:final data) => data,
      Error(:final failure) =>
        logFailure('localized content', failure) ??
            const LocalizedContentBundle.empty(),
    };

    if (progress != null && subjects != null && recentStudies != null) {
      final vaultItems = subjects
          .map(
            (subject) => FormulaVaultItem(
              id: subject.id,
              label: subject.category.toUpperCase(),
              title: subject.name.split(' & ').first,
            ),
          )
          .toList();

      emit(
        state.copyWith(
          status: DashboardStatus.loaded,
          progress: progress,
          subjects: subjects,
          recentStudies: recentStudies,
          vaultItems: vaultItems,
          banners: banners ?? const [],
          announcements: announcements ?? const [],
          weakAreas: weakAreas ?? const [],
          selectedBoardName: curriculum.boardName,
          selectedGradeName: curriculum.gradeLabel,
          localizedContent: localizedContent.values,
          errorMessage: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: DashboardStatus.error,
        errorMessage: AppStrings.failedToLoadDashboard,
      ),
    );
  }

  Future<void> retryLoadDashboard({int maxAttempts = 2}) async {
    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      AppLogger.info(
        'Retrying dashboard load (attempt $attempt/$maxAttempts)',
        tag: AppLogTags.dashboardCubit,
      );

      await loadDashboard();
      if (state.status == DashboardStatus.loaded) {
        return;
      }

      if (attempt < maxAttempts) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
      }
    }
  }

  void setBannerIndex(int index) {
    emit(state.copyWith(currentBannerIndex: index));
  }

  void setAnnouncementIndex(int index) {
    emit(state.copyWith(currentAnnouncementIndex: index));
  }

  void dismissAnnouncement(String announcementId) {
    if (state.dismissedAnnouncementIds.contains(announcementId)) {
      return;
    }

    final dismissedAnnouncementIds = [
      ...state.dismissedAnnouncementIds,
      announcementId,
    ];
    final visibleCount = state.announcements
        .where(
          (announcement) => !dismissedAnnouncementIds.contains(announcement.id),
        )
        .length;
    final nextIndex = visibleCount <= 1
        ? 0
        : state.currentAnnouncementIndex.clamp(0, visibleCount - 1);

    emit(
      state.copyWith(
        dismissedAnnouncementIds: dismissedAnnouncementIds,
        currentAnnouncementIndex: nextIndex,
      ),
    );
  }
}
