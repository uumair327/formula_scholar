import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../domain/domain.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/widgets.dart';

/// Dashboard page – the main landing screen of the app.
///
/// All content sections are **data-driven** — the subject grid,
/// formula vault, and continue-studying list are rendered from
/// state provided by [DashboardCubit]. No UI code references
/// specific subjects (Math, Physics, etc.) ensuring any subject
/// added by the backend renders correctly (Open/Closed Principle).
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DashboardCubit, DashboardState>(
      listenWhen: (prev, curr) => prev.subjects != curr.subjects,
      listener: (context, state) {
        if (state.subjects.isNotEmpty) {
          final selectedSubjects = state.subjects
              .map(
                (s) => SelectedSubject(
                  id: s.id,
                  name: s.name,
                  category: s.category,
                  description: s.description,
                  subtitle: s.subtitle ?? '',
                ),
              )
              .toList();
          context.read<SubjectSelectionCubit>().updateAvailableSubjects(
            selectedSubjects,
          );
        }
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
        buildWhen: (prev, curr) => prev.status != curr.status,
        builder: (context, state) {
          if (state.status == DashboardStatus.loading ||
              state.status == DashboardStatus.initial) {
            return const Scaffold(body: AppLoadingState());
          }

          if (state.status == DashboardStatus.error) {
            return Scaffold(
              body: AppErrorState(
                message: state.errorMessage,
                onRetry: () =>
                    context.read<DashboardCubit>().retryLoadDashboard(),
              ),
            );
          }

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: AppDimensions.paddingLG),
                      _buildCurriculumFilterBar(context),
                      const SizedBox(height: AppDimensions.paddingXL),
                      _buildHeroStatusCard(context, state),
                      const SizedBox(height: AppDimensions.paddingSection),
                      _buildAcademicPath(context, state),
                      const SizedBox(height: AppDimensions.paddingSection),
                      _buildFormulaVault(context, state),
                      const SizedBox(height: AppDimensions.paddingLG),
                      _buildContinueStudying(context, state),
                      const SizedBox(height: AppDimensions.bottomNavPadding),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────── App Bar ─────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        final user = authState.user;
        final userName = user?.displayName ?? AppStrings.dashboardSanctuary;
        final photoUrl = user?.photoUrl ?? AppAssets.dashboardStudentProfileUrl;

        return SliverAppBar(
          floating: true,
          snap: true,
          backgroundColor: AppColors.surface.withValues(
            alpha: AppDimensions.opacityHigh,
          ),
          surfaceTintColor: AppColors.transparent,
          title: GestureDetector(
            onTap: () => context.go(AppRoutes.profilePath),
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Container(
                  width: AppDimensions.avatarMD,
                  height: AppDimensions.avatarMD,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryFixed,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) =>
                        const Icon(LucideIcons.user, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Text(
                  userName,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // Navigate to Chapters tab for browsing
                final shell = StatefulNavigationShell.of(context);
                shell.goBranch(1);
              },
              icon: const Icon(LucideIcons.search, color: AppColors.outline),
            ),
            const SizedBox(width: AppDimensions.paddingSM),
          ],
        );
      },
    );
  }

  Widget _buildCurriculumFilterBar(BuildContext context) {
    return BlocBuilder<CurriculumCubit, CurriculumState>(
      buildWhen: (prev, curr) =>
          prev.curriculum != curr.curriculum ||
          prev.isLoading != curr.isLoading,
      builder: (context, curriculum) {
        final selection = curriculum.curriculum;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.slidersHorizontal,
                      size: AppDimensions.iconSM,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppDimensions.paddingXS),
                    Text(
                      AppStrings.dashboardActiveCurriculum,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: AppDimensions.opacityMedium,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.onboardingPath),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSM,
                      vertical: AppDimensions.paddingXXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(
                        alpha: AppDimensions.opacityFaint,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXXL,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.arrowLeftRight,
                          size: AppDimensions.iconSM,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppDimensions.paddingXXS),
                        Text(
                          AppStrings.dashboardSwitchBoardGrade,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: AppDimensions.fontSizeXSPlus,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            // Active curriculum badge
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Board badge
                  _CurriculumBadge(
                    icon: LucideIcons.layoutGrid,
                    iconColor: AppColors.primary,
                    label:
                        selection?.boardName ??
                        AppStrings.dashboardCurriculumPending,
                    isActive: true,
                    activeColor: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Container(
                    width: AppDimensions.borderWidth,
                    height: AppDimensions.paddingXXL,
                    color: AppColors.surfaceContainerHighest,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  // Grade badge
                  _CurriculumBadge(
                    icon: LucideIcons.graduationCap,
                    iconColor: AppColors.secondary,
                    label:
                        selection?.gradeLabel ??
                        AppStrings.dashboardCurriculumPending,
                    isActive: true,
                    activeColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ──────────────────────── Hero Status Card ────────────────────

  Widget _buildHeroStatusCard(BuildContext context, DashboardState state) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: const SignatureGlowDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Curriculum badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.chipPaddingHorizontal,
                  vertical: AppDimensions.badgePaddingVertical,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: AppDimensions.dotIndicatorSize,
                      height: AppDimensions.dotIndicatorSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryFixed,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Text(
                      state.heroBadge,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimensions.fontSizeXS,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              // Title
              Text(
                state.heroTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                  height: AppDimensions.lineHeightCompact,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              // Description
              Text(
                state.heroDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primaryFixed.withValues(
                    alpha: AppDimensions.opacityNearOpaque,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              // Resume button
              ElevatedButton(
                onPressed: () {
                  _resumeLearning(context, state);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingHero,
                    vertical: AppDimensions.progressBarLG,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                  ),
                  elevation: AppDimensions.elevationMD,
                  textStyle: AppTextStyles.labelLarge,
                ),
                child: const Text(AppStrings.dashboardResumeLesson),
              ),
            ],
          ),
          // Decorative circle
          Positioned(
            top: -AppDimensions.paddingSM,
            right: -AppDimensions.paddingSM,
            child: Container(
              width: AppDimensions.glowCircleSizeSM,
              height: AppDimensions.glowCircleSizeSM,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resumeLearning(BuildContext context, DashboardState state) {
    final featured = state.subjects.where((s) => s.isFeatured).toList();
    if (featured.isNotEmpty) {
      _onSubjectTap(context, featured.first);
      return;
    }
    if (state.subjects.isNotEmpty) {
      _onSubjectTap(context, state.subjects.first);
      return;
    }
    context.read<SubjectSelectionCubit>().clearSelection();
    StatefulNavigationShell.of(context).goBranch(1);
  }

  // ──────────────────────── Academic Path ───────────────────────

  Widget _buildAcademicPath(BuildContext context, DashboardState state) {
    final subjects = state.subjects;
    // Separate featured subject (first card, gets larger layout)
    final featured = subjects.where((s) => s.isFeatured).toList();
    final others = subjects.where((s) => !s.isFeatured).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.dashboardAcademicPath,
          actionLabel: AppStrings.viewAll,
          onAction: () {
            context.read<SubjectSelectionCubit>().clearSelection();
            StatefulNavigationShell.of(context).goBranch(1);
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > AppDimensions.breakpointWide;
            if (isWide) {
              return Column(
                children: [
                  // Row 1: featured + first other
                  if (featured.isNotEmpty || others.isNotEmpty)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (featured.isNotEmpty)
                            Expanded(
                              flex: 2,
                              child: SubjectCard(
                                subject: featured.first,
                                onTap: () =>
                                    _onSubjectTap(context, featured.first),
                              ),
                            ),
                          if (featured.isNotEmpty && others.isNotEmpty)
                            const SizedBox(width: AppDimensions.paddingLG),
                          if (others.isNotEmpty)
                            Expanded(
                              child: SubjectCard(
                                subject: others.first,
                                onTap: () =>
                                    _onSubjectTap(context, others.first),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  // Row 2: remaining others + quiz
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      spacing: AppDimensions.paddingLG,
                      runSpacing: AppDimensions.paddingLG,
                      alignment: WrapAlignment.start,
                      children: [
                        ...others.skip(1).map((subject) {
                          // Roughly 50% width minus padding for 2-column layout
                          final itemWidth =
                              (constraints.maxWidth - AppDimensions.paddingLG) /
                              2.05;
                          return SizedBox(
                            width: itemWidth,
                            child: SubjectCard(
                              subject: subject,
                              onTap: () => _onSubjectTap(context, subject),
                            ),
                          );
                        }),
                        SizedBox(
                          width:
                              (constraints.maxWidth - AppDimensions.paddingLG) /
                              2.05,
                          child: _buildQuizCard(context),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            // Mobile: stack all subjects vertically
            return Column(
              children: [
                ...subjects.map(
                  (subject) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingLG,
                    ),
                    child: SubjectCard(
                      subject: subject,
                      onTap: () => _onSubjectTap(context, subject),
                    ),
                  ),
                ),
                _buildQuizCard(context),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Handles tap on a subject card — selects the subject and
  /// navigates to the Chapters tab.
  void _onSubjectTap(BuildContext context, Subject subject) {
    context.read<SubjectSelectionCubit>().selectSubject(
      id: subject.id,
      name: subject.name,
      category: subject.category,
      description: subject.description,
      subtitle: subject.subtitle ?? '',
    );
    final shell = StatefulNavigationShell.of(context);
    shell.goBranch(1);
  }

  // ──────────── Quiz Card ────────────

  Widget _buildQuizCard(BuildContext context) {
    return AppCard(
      color: AppColors.primary.withValues(alpha: AppDimensions.opacityOverlay),
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: AppDimensions.opacityFaint),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.helpCircle,
                size: AppDimensions.avatarMD,
                backgroundColor: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusXL,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingSM,
                  vertical: AppDimensions.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                child: Text(
                  AppStrings.dashboardLive,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontSize: AppDimensions.fontSizeXXSPlus,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.dashboardBoardReadyQuiz,
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.dashboardQuizDesc,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Practice tab (index 2)
                final shell = StatefulNavigationShell.of(context);
                shell.goBranch(2);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.progressBarMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
              child: const Text(AppStrings.startNow),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────── Formula Vault ───────────────────────

  Widget _buildFormulaVault(BuildContext context, DashboardState state) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      border: Border.all(color: AppColors.surfaceContainerHigh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  boxShadow: const [AppShadows.subtle],
                ),
                child: const Icon(
                  LucideIcons.folderOpen,
                  size: AppDimensions.iconLG,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.dashboardFormulaVault,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      state.vaultDescription,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          _buildVaultGrid(context, state),
        ],
      ),
    );
  }

  /// Data-driven vault grid — items come from [DashboardState.vaultItems].
  Widget _buildVaultGrid(BuildContext context, DashboardState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointMedium;
        final crossAxisCount = isWide ? 4 : 2;
        // Items from state + an "add" slot
        final vaultItems = state.vaultItems;
        final totalCount = vaultItems.length + 1; // +1 for "add new" card

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppDimensions.paddingMD,
            crossAxisSpacing: AppDimensions.paddingMD,
            childAspectRatio: AppDimensions.vaultGridAspectRatio,
          ),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            // Last card = "Add new" slot
            if (index >= vaultItems.length) {
              return Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () {
                    // Navigate to Saved tab (index 3)
                    final shell = StatefulNavigationShell.of(context);
                    shell.goBranch(3);
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      border: Border.all(
                        color: AppColors.surfaceContainerHighest,
                        width: AppDimensions.borderWidth,
                      ),
                      boxShadow: const [AppShadows.subtle],
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.plus,
                        size: AppDimensions.iconLG,
                        color: AppColors.surfaceDim,
                      ),
                    ),
                  ),
                ),
              );
            }
            final item = vaultItems[index];
            return Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  _navigateFromVaultItem(context, state, item);
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                    border: Border.all(color: AppColors.surfaceContainerHigh),
                    boxShadow: const [AppShadows.subtle],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.slate400,
                          fontSize: AppDimensions.fontSizeXS,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        item.title,
                        style: AppTextStyles.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateFromVaultItem(
    BuildContext context,
    DashboardState state,
    FormulaVaultItem item,
  ) {
    Subject? subject;
    for (final s in state.subjects) {
      if (s.id == item.id) {
        subject = s;
        break;
      }
    }

    if (subject != null) {
      _onSubjectTap(context, subject);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(3);
  }

  // ──────────────────────── Continue Studying ───────────────────

  /// Data-driven recent studies list — uses [RecentStudy.iconName]
  /// and [RecentStudy.colorValue] instead of hardcoded `isMath` checks.
  Widget _buildContinueStudying(BuildContext context, DashboardState state) {
    if (state.recentStudies.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.continueStudying,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              AppStrings.dashboardNoRecentTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              AppStrings.dashboardNoRecentDescription,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            ElevatedButton(
              onPressed: () => StatefulNavigationShell.of(context).goBranch(1),
              child: const Text(AppStrings.dashboardOpenChapters),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.continueStudying,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        ...state.recentStudies.map((study) {
          final iconData = AppIconMapper.resolve(study.iconName);
          final accentColor = Color(study.colorValue);
          final bgColor = Color(study.backgroundColorValue);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
            child: Material(
              color: AppColors.transparent,
              child: InkWell(
                onTap: () {
                  _onRecentStudyTap(context, state, study);
                },
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                child: AppCard(
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  child: Row(
                    children: [
                      AppIconCircle(
                        icon: iconData,
                        size: AppDimensions.avatarLG,
                        backgroundColor: bgColor,
                        iconColor: accentColor,
                        iconSize: AppDimensions.iconLG,
                      ),
                      const SizedBox(width: AppDimensions.paddingLG),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              study.title,
                              style: AppTextStyles.labelLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: AppDimensions.paddingXXS),
                            Text(
                              '${study.subject} • ${study.lastViewed}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        LucideIcons.chevronRight,
                        size: AppDimensions.iconMD,
                        color: AppColors.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _onRecentStudyTap(
    BuildContext context,
    DashboardState state,
    RecentStudy study,
  ) {
    if (study.subjectId.isNotEmpty) {
      final byId = state.subjects
          .where((s) => s.id == study.subjectId)
          .toList();
      if (byId.isNotEmpty) {
        _onSubjectTap(context, byId.first);
        return;
      }
    }

    final byName = state.subjects
        .where((s) => s.name.toLowerCase() == study.subject.toLowerCase())
        .toList();
    if (byName.isNotEmpty) {
      _onSubjectTap(context, byName.first);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(1);
  }
}

/// A compact pill-shaped badge showing the active curriculum value.
class _CurriculumBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool isActive;
  final Color activeColor;

  const _CurriculumBadge({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.isActive,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: AppDimensions.opacityFaint),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        border: Border.all(
          color: activeColor.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppDimensions.iconSM, color: iconColor),
          const SizedBox(width: AppDimensions.paddingXS),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: activeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
