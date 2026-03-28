import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

/// Dashboard page – the main landing screen of the app.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
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
                  context.read<DashboardCubit>().loadDashboard(),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildGreetingSection(),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildGradeFilterChips(),
                    const SizedBox(height: AppDimensions.paddingLG),
                    _buildSearchBar(),
                    const SizedBox(height: AppDimensions.paddingHero),
                    _buildMasteryAndChallenge(state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildExploreSubjects(context, state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildContinueStudying(state),
                    const SizedBox(height: AppDimensions.bottomNavPadding),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surface.withValues(alpha: AppDimensions.opacityHigh),
      surfaceTintColor: AppColors.transparent,
      title: Row(
        children: [
          const AppAvatar(imageUrl: AppAssets.dashboardAvatarUrl),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.welcomeScholar,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimaryFixedVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            AppLogger.debug('Stats button tapped',
                tag: AppLogTags.dashboardPage);
          },
          icon: const Icon(LucideIcons.barChart3, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  Widget _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dashboard,
          style: AppTextStyles.overline.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: AppDimensions.letterSpacingWide,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          AppStrings.hiSarahReady,
          style: AppTextStyles.displayLarge,
        ),
      ],
    );
  }

  Widget _buildGradeFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _GradeChip(label: AppStrings.grade9th, isActive: true),
          const SizedBox(width: AppDimensions.paddingSM),
          _GradeChip(label: AppStrings.grade10th, isActive: false),
          const SizedBox(width: AppDimensions.paddingSM),
          _GradeChip(label: AppStrings.grade11th, isActive: false),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: const [AppShadows.ghost],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: AppDimensions.opacityMedium),
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
                left: AppDimensions.paddingXL, right: AppDimensions.paddingMD),
            child: Icon(LucideIcons.search,
                color: AppColors.outline, size: AppDimensions.iconMD),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingXL,
          ),
        ),
      ),
    );
  }

  Widget _buildMasteryAndChallenge(DashboardState state) {
    final progress = state.progress;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > AppDimensions.breakpointWide;
        if (isWide) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: _buildMasteryCard(progress)),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(child: _buildDailyChallengeCard()),
              ],
            ),
          );
        }
        return Column(
          children: [
            _buildMasteryCard(progress),
            const SizedBox(height: AppDimensions.paddingLG),
            _buildDailyChallengeCard(),
          ],
        );
      },
    );
  }

  Widget _buildMasteryCard(dynamic progress) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.overallMastery,
                  style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.masteryDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${progress?.masteryPercentage?.toInt() ?? 0}%',
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${progress?.completedChapters ?? 0}/${progress?.totalChapters ?? 0} ${AppStrings.chaptersLabel}',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              ProgressBar(
                percentage: progress?.masteryPercentage ?? 0,
                height: AppDimensions.progressBarLG,
              ),
            ],
          ),
          Positioned(
            right: AppDimensions.decorativeOffsetLG,
            bottom: AppDimensions.decorativeOffsetLG,
            child: Container(
              width: AppDimensions.glowCircleSize,
              height: AppDimensions.glowCircleSize,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: AppDimensions.opacityFaint),
                    blurRadius: AppDimensions.blurRadiusXL,
                    spreadRadius: AppDimensions.spreadRadiusMD,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChallengeCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: const SignatureGlowDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIconCircle(
            icon: LucideIcons.zap,
            size: AppDimensions.avatarHero,
            backgroundColor: AppColors.white.withValues(alpha: AppDimensions.opacitySubtle),
            iconColor: AppColors.white,
            iconSize: AppDimensions.iconXXL,
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.dailyChallenge,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            AppStrings.dailyChallengeDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryFixedDim.withValues(alpha: AppDimensions.opacityNearOpaque),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppLogger.debug('Daily Challenge tapped',
                    tag: AppLogTags.dashboardPage);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.progressBarLG),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXXL),
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

  Widget _buildExploreSubjects(BuildContext context, DashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.exploreSubjects,
          actionLabel: AppStrings.viewAll,
          onAction: () {
            AppLogger.debug('View All tapped', tag: AppLogTags.dashboardPage);
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide =
                constraints.maxWidth > AppDimensions.breakpointWide;
            if (isWide) {
              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 7, child: _buildMathCard(context)),
                        const SizedBox(width: AppDimensions.paddingLG),
                        Expanded(flex: 5, child: _buildPhysicsCard()),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 5, child: _buildChemistryCard()),
                        const SizedBox(width: AppDimensions.paddingLG),
                        Expanded(
                            flex: 7, child: _buildCheatSheetCard(context)),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                _buildMathCard(context),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildPhysicsCard(),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildChemistryCard(),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildCheatSheetCard(context),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMathCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppLogger.info('Navigating to Geometry',
            tag: AppLogTags.dashboardPage);
        context.goNamed(AppRoutes.geometryName);
      },
      child: AppCard(
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minHeight: AppDimensions.cardMinHeightLG),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide =
                  constraints.maxWidth > AppDimensions.breakpointCardHorizontal;
              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(AppDimensions.paddingHero),
                        child: _buildMathCardContent(),
                      ),
                    ),
                    Expanded(child: _buildMathCardImage()),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                    child: _buildMathCardContent(),
                  ),
                  SizedBox(
                    height: AppDimensions.imagePreviewHeight,
                    width: double.infinity,
                    child: _buildMathCardImage(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMathCardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryChip(label: AppStrings.mathematics),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              AppStrings.numberSystemsGeometry,
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              AppStrings.mathCardDescription,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: AppDimensions.paddingXL),
          child: Wrap(
            spacing: AppDimensions.paddingSM,
            children: const [
              AppInfoChip(label: '8 Units'),
              AppInfoChip(label: '124 Formulas'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMathCardImage() {
    return Container(
      color: AppColors.primaryContainer.withValues(alpha: AppDimensions.opacitySubtle),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.6,
            child: CachedNetworkImage(
              imageUrl: AppAssets.mathSubjectImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const Icon(
                LucideIcons.bookOpen,
                size: AppDimensions.iconHero,
                color: AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicsCard() {
    return AppCard(
      color: AppColors.tertiaryFixed,
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconCircle(
                icon: LucideIcons.gauge,
                size: AppDimensions.avatarLG,
                backgroundColor: AppColors.white,
                iconColor: AppColors.tertiary,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusLG,
                boxShadow: const [AppShadows.subtle],
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Text(
                AppStrings.physics,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onTertiaryFixed,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                AppStrings.physicsDesc,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onTertiaryFixedVariant,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingXXL),
            child: AppActionRow(
              label: AppStrings.enterLab,
              color: AppColors.tertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChemistryCard() {
    return AppCard(
      color: AppColors.secondaryContainer,
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconCircle(
                icon: LucideIcons.flaskConical,
                size: AppDimensions.avatarLG,
                backgroundColor: AppColors.white,
                iconColor: AppColors.secondary,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusLG,
                boxShadow: const [AppShadows.subtle],
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              Text(
                AppStrings.chemistry,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.onSecondaryFixed,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                AppStrings.chemistryDesc,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSecondaryFixedVariant,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingXXL),
            child: AppActionRow(
              label: AppStrings.exploreElements,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheatSheetCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppLogger.info('Navigating to Algebra',
            tag: AppLogTags.dashboardPage);
        context.goNamed(AppRoutes.algebraName);
      },
      child: AppCard(
        color: AppColors.surfaceContainerHigh,
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: AppDimensions.opacityLight),
          width: AppDimensions.borderWidth,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.formulaCheatSheets,
                    style: AppTextStyles.headlineSmall,
                  ),
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    AppStrings.cheatSheetDesc,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingLG),
            const AppIconCircle(
              icon: LucideIcons.download,
              size: AppDimensions.avatarHero,
              backgroundColor: AppColors.surfaceContainerLowest,
              iconColor: AppColors.primary,
              iconSize: AppDimensions.iconXL,
            ),
          ],
        ),
      ),
    );
  }

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
          final isGeometry = study.subject == AppStrings.geometry;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
            child: AppCard(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: Row(
                children: [
                  AppIconCircle(
                    icon: isGeometry
                        ? LucideIcons.calculator
                        : LucideIcons.atom,
                    size: AppDimensions.avatarLG,
                    backgroundColor: isGeometry
                        ? AppColors.primaryFixed
                        : AppColors.secondaryFixed,
                    iconColor: isGeometry
                        ? AppColors.primary
                        : AppColors.secondary,
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

/// Grade filter chip widget (9th, 10th, 11th Standard).
class _GradeChip extends StatelessWidget {
  final String label;
  final bool isActive;

  const _GradeChip({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppLogger.debug('Grade chip tapped: $label',
            tag: AppLogTags.dashboardPage);
      },
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.progressBarMD),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : AppColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
          boxShadow: isActive ? const [AppShadows.chip] : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: isActive
                ? AppColors.onPrimary
                : AppColors.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
