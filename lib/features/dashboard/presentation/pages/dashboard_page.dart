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
          final selectedSubjects = state.subjects.map((s) => SelectedSubject(
            id: s.id,
            name: s.name,
            category: s.category,
            description: s.description,
            subtitle: s.subtitle ?? '',
          )).toList();
          context.read<SubjectSelectionCubit>().updateAvailableSubjects(selectedSubjects);
        }
      },
      child: BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading ||
            state.status == DashboardStatus.initial) {
          return const Scaffold(body: AppLoadingState());
        }

        if (state.status == DashboardStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () => context.read<DashboardCubit>().loadDashboard(),
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
                    _buildHeroStatusCard(state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildAcademicPath(context, state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildFormulaVault(state),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildContinueStudying(state),
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

  SliverAppBar _buildAppBar(BuildContext context) {
    final authRepo = getIt<AuthRepositoryPort>();
    final user = authRepo.currentUser;
    final userName = user?.displayName ?? AppStrings.dashboardSanctuary;
    final photoUrl = user?.photoUrl ?? AppAssets.dashboardStudentProfileUrl;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surface.withValues(
        alpha: AppDimensions.opacityHigh,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Row(
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
      actions: [
        IconButton(
          onPressed: () {
            AppLogger.debug('Search tapped', tag: AppLogTags.dashboardPage);
          },
          icon: const Icon(LucideIcons.search, color: AppColors.outline),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  // ──────────────────────── Curriculum Filter Bar ───────────────

  Widget _buildCurriculumFilterBar(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      buildWhen: (prev, curr) =>
          prev.selectedBoardIndex != curr.selectedBoardIndex ||
          prev.selectedGradeIndex != curr.selectedGradeIndex ||
          prev.availableBoards != curr.availableBoards ||
          prev.availableGrades != curr.availableGrades,
      builder: (context, state) {
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
                  onTap: () {
                    AppLogger.info(
                      'Switch Board/Grade tapped',
                      tag: AppLogTags.dashboardPage,
                    );
                    context.go(AppRoutes.onboardingPath);
                  },
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
            // Filter chips row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Board category chip group
                  FilterChipGroup(
                    icon: LucideIcons.layoutGrid,
                    iconColor: AppColors.primary,
                    chips: state.availableBoards,
                    activeIndex: state.selectedBoardIndex,
                    activeColor: AppColors.primary,
                    onChanged: (index) {
                      context.read<DashboardCubit>().switchBoard(index);
                    },
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Container(
                    width: 1,
                    height: AppDimensions.paddingXXL,
                    color: AppColors.surfaceContainerHighest,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  // Grade category chip group
                  FilterChipGroup(
                    icon: LucideIcons.graduationCap,
                    iconColor: AppColors.secondary,
                    chips: state.availableGrades,
                    activeIndex: state.selectedGradeIndex,
                    activeColor: AppColors.secondary,
                    onChanged: (index) {
                      context.read<DashboardCubit>().switchGrade(index);
                    },
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

  Widget _buildHeroStatusCard(DashboardState state) {
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
                AppStrings.dashboardHeroTitle,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                  height: AppDimensions.lineHeightCompact,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              // Description
              Text(
                AppStrings.dashboardHeroDescription,
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
                  AppLogger.debug(
                    'Resume Lesson tapped',
                    tag: AppLogTags.dashboardPage,
                  );
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
            AppLogger.debug('View All tapped', tag: AppLogTags.dashboardPage);
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
                            Expanded(child: SubjectCard(
                              subject: others.first,
                              onTap: () => _onSubjectTap(context, others.first),
                            )),
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
                          final itemWidth = (constraints.maxWidth - AppDimensions.paddingLG) / 2.05;
                          return SizedBox(
                            width: itemWidth,
                            child: SubjectCard(
                              subject: subject,
                              onTap: () => _onSubjectTap(context, subject),
                            ),
                          );
                        }),
                        SizedBox(
                           width: (constraints.maxWidth - AppDimensions.paddingLG) / 2.05,
                           child: _buildQuizCard(),
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
                _buildQuizCard(),
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
    AppLogger.info(
      'Navigating to Chapters (${subject.category})',
      tag: AppLogTags.dashboardPage,
    );
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

  Widget _buildQuizCard() {
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
                AppLogger.debug(
                  'Start Quiz tapped',
                  tag: AppLogTags.dashboardPage,
                );
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

  Widget _buildFormulaVault(DashboardState state) {
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
                      AppStrings.dashboardVaultDesc,
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
          _buildVaultGrid(state),
        ],
      ),
    );
  }

  /// Data-driven vault grid — items come from [DashboardState.vaultItems].
  Widget _buildVaultGrid(DashboardState state) {
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
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
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
              );
            }
            final item = vaultItems[index];
            return Container(
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
            );
          },
        );
      },
    );
  }

  // ──────────────────────── Continue Studying ───────────────────

  /// Data-driven recent studies list — uses [RecentStudy.iconName]
  /// and [RecentStudy.colorValue] instead of hardcoded `isMath` checks.
  Widget _buildContinueStudying(DashboardState state) {
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
          );
        }),
      ],
    );
  }
}
