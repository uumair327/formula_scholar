import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/subject.dart';
import '../cubit/daily_challenges_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import 'widgets.dart';

class DashboardHeroSection extends StatelessWidget {
  final DashboardState state;
  final Function(BuildContext, DashboardState) onResume;

  const DashboardHeroSection({
    super.key,
    required this.state,
    required this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final String heroBadge =
        (state.localizedContent['dashboard.hero.badge']?.trim().isNotEmpty ??
                false)
            ? state.localizedContent['dashboard.hero.badge']!
            : context.l10n.dashboardHeroBadge;

    final String heroTitle =
        (state.localizedContent['dashboard.hero.title']?.trim().isNotEmpty ??
                false)
            ? state.localizedContent['dashboard.hero.title']!
            : context.l10n.dashboardHeroTitle;

    final progressVal = state.progress?.masteryPercentage.toInt() ?? 0;
    String heroDescription;
    if (state.localizedContent['dashboard.hero.description']?.trim().isNotEmpty ??
        false) {
      heroDescription = state.localizedContent['dashboard.hero.description']!
          .replaceAll('{progress}', progressVal.toString());
    } else {
      heroDescription = context.l10n.dashboardHeroDescription(progressVal);
    }

    final String resumeLabel =
        (state.localizedContent['dashboard.hero.resume']?.trim().isNotEmpty ??
                false)
            ? state.localizedContent['dashboard.hero.resume']!
            : context.l10n.dashboardResumeLesson;

    final String semanticLabel = (state
                .localizedContent['dashboard.hero.resumeSemantic']
                ?.trim()
                .isNotEmpty ??
            false)
        ? state.localizedContent['dashboard.hero.resumeSemantic']!
        : context.l10n.dashboardResumeSemantic;

    return HeroStatusCard(
      badge: heroBadge,
      title: heroTitle,
      description: heroDescription,
      resumeLabel: resumeLabel,
      semanticLabel: semanticLabel,
      onResume: () => onResume(context, state),
    );
  }
}

class DashboardQuickActionsSection extends StatelessWidget {
  final DashboardState state;

  const DashboardQuickActionsSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final sectionTitle = (state
                .localizedContent['dashboard.quickActions.title']
                ?.trim()
                .isNotEmpty ??
            false)
        ? state.localizedContent['dashboard.quickActions.title']!
        : context.l10n.quickActionsTitle;

    final studyPlannerLabel = (state
                .localizedContent['dashboard.quickActions.studyPlanner']
                ?.trim()
                .isNotEmpty ??
            false)
        ? state.localizedContent['dashboard.quickActions.studyPlanner']!
        : context.l10n.studyPlanner;

    final analyticsLabel = (state
                .localizedContent['dashboard.quickActions.analytics']
                ?.trim()
                .isNotEmpty ??
            false)
        ? state.localizedContent['dashboard.quickActions.analytics']!
        : context.l10n.viewAnalytics;

    final flashcardsLabel = (state
                .localizedContent['dashboard.quickActions.flashcards']
                ?.trim()
                .isNotEmpty ??
            false)
        ? state.localizedContent['dashboard.quickActions.flashcards']!
        : context.l10n.flashcards;

    return QuickActionsSection(
      sectionTitle: sectionTitle,
      studyPlannerLabel: studyPlannerLabel,
      analyticsLabel: analyticsLabel,
      flashcardsLabel: flashcardsLabel,
    );
  }
}

class DashboardFormulaVaultSection extends StatelessWidget {
  final DashboardState state;

  const DashboardFormulaVaultSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final vaultDesc =
        (state.localizedContent['dashboard.vault.description']?.trim().isNotEmpty ??
                false)
            ? state.localizedContent['dashboard.vault.description']!
            : context.l10n.dashboardVaultDescWithCounts(
                state.subjects.fold<int>(
                  0,
                  (sum, s) => sum + s.formulaCount,
                ),
                state.subjects.length,
              );
    return FormulaVaultSection(
      description: vaultDesc,
      vaultItems: state.vaultItems,
      subjects: state.subjects,
      onVaultItemTap: (subject) {
        context.goNamed(
          AppRoutes.savedName,
          queryParameters: {'subject': subject.name},
        );
      },
    );
  }
}

class DashboardAnnouncementSection extends StatelessWidget {
  final DashboardState state;

  const DashboardAnnouncementSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.announcements
        .where((a) => a.isUrgent || a.isHighPriority)
        .isEmpty) {
      return const SizedBox.shrink();
    }
    return AnnouncementBanner(
      announcements: state.announcements,
      dismissedAnnouncementIds: state.dismissedAnnouncementIds,
      currentIndex: state.currentAnnouncementIndex,
      onPageChanged: (index) =>
          context.read<DashboardCubit>().setAnnouncementIndex(index),
      onDismiss: (id) =>
          context.read<DashboardCubit>().dismissAnnouncement(id),
    );
  }
}

class DashboardBannersSection extends StatelessWidget {
  final DashboardState state;

  const DashboardBannersSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.banners.where((b) => b.isActive).isEmpty) {
      return const SizedBox.shrink();
    }
    return EntranceWrapper(
      delay: const Duration(milliseconds: 50),
      child: CarouselBanners(
        banners: state.banners,
        currentPage: state.currentBannerIndex,
        onPageChanged: (index) =>
            context.read<DashboardCubit>().setBannerIndex(index),
      ),
    );
  }
}

class DashboardAcademicPathSection extends StatelessWidget {
  final DashboardState state;
  final void Function(BuildContext, Subject) onSubjectTap;
  final void Function(BuildContext, DashboardState, Subject) showSubjectAnalytics;

  const DashboardAcademicPathSection({
    super.key,
    required this.state,
    required this.onSubjectTap,
    required this.showSubjectAnalytics,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DailyChallengesCubit>(),
      child: AcademicPathSection(
        subjects: state.subjects,
        onSubjectTap: (subject) => onSubjectTap(context, subject),
        onShowAnalytics: (subject) =>
            showSubjectAnalytics(context, state, subject),
        onViewAll: () {
          context.read<SubjectSelectionCubit>().clearSelection();
          StatefulNavigationShell.of(context).goBranch(1);
        },
      ),
    );
  }
}
