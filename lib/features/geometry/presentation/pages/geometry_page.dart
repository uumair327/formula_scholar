import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/geometry_cubit.dart';
import '../cubit/geometry_state.dart';

/// Geometry page – chapter details with topic cards and mastery tools.
class GeometryPage extends StatelessWidget {
  const GeometryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryCubit, GeometryState>(
      builder: (context, state) {
        if (state.status == GeometryStatus.loading ||
            state.status == GeometryStatus.initial) {
          return const Scaffold(body: AppLoadingState());
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
                    _buildHeroSection(),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    _buildTopicCards(state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildMasteryTools(),
                    const SizedBox(height: AppDimensions.bottomNavPadding),
                  ]),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              AppLogger.debug('Play FAB tapped',
                  tag: AppLogTags.geometryPage);
            },
            backgroundColor: AppColors.primary,
            child: const Icon(LucideIcons.play, color: AppColors.white),
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor:
          AppColors.surfaceContainerLowest.withValues(alpha: AppDimensions.opacityAppBar),
      surfaceTintColor: AppColors.transparent,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.geometry,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onPrimaryFixedVariant,
            ),
          ),
          Row(
            children: [
              Text(
                AppStrings.breadcrumbHome,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
              const Icon(LucideIcons.chevronRight,
                  size: AppDimensions.iconXS, color: AppColors.slate400),
              Text(
                AppStrings.breadcrumbMath,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
              const Icon(LucideIcons.chevronRight,
                  size: AppDimensions.iconXS, color: AppColors.slate400),
              Text(
                AppStrings.breadcrumbGeometry,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.primary,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        AppIconCircle(
          icon: LucideIcons.barChart3,
          size: AppDimensions.avatarMD,
          backgroundColor: AppColors.primaryFixed,
          iconColor: AppColors.primary,
          iconSize: AppDimensions.iconMD,
          borderRadius: AppDimensions.radiusMD,
        ),
        const SizedBox(width: AppDimensions.paddingMD),
        AppAvatar(
          imageUrl: AppAssets.geometryAvatarUrl,
          placeholderColor: AppColors.surfaceContainerHighest,
        ),
        const SizedBox(width: AppDimensions.paddingLG),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingHero),
      decoration: const SignatureGlowDecoration(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInfoChip(
                label: AppStrings.chapter04,
                backgroundColor: AppColors.white.withValues(alpha: AppDimensions.opacitySubtle),
                textColor: AppColors.white,
                textStyle:
                    AppTextStyles.overline.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                AppStrings.visualizingSpace,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.geometryHeroDesc,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.blue50,
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
          ),
          Positioned(
            right: AppDimensions.decorativeOffset,
            bottom: AppDimensions.decorativeOffset,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: AppDimensions.rotationSubtle,
                child: const Icon(
                  LucideIcons.compass,
                  size: AppDimensions.iconDecorative,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCards(GeometryState state) {
    final topics = state.topics;
    if (topics.isEmpty) return const SizedBox();

    return Column(
      children: [
        if (topics.isNotEmpty) _buildTrianglesCard(topics[0]),
        const SizedBox(height: AppDimensions.paddingLG),
        if (topics.length > 1) _buildCompactTopicCard(topics[1]),
        const SizedBox(height: AppDimensions.paddingLG),
        if (topics.length > 2) _buildQuadrilateralsCard(topics[2]),
        const SizedBox(height: AppDimensions.paddingLG),
        if (topics.length > 3) _buildCoordinatesCard(topics[3]),
        const SizedBox(height: AppDimensions.paddingLG),
        if (topics.length > 4) _buildLockedCard(topics[4]),
      ],
    );
  }

  Widget _buildTrianglesCard(dynamic topic) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppIconCircle(
                icon: LucideIcons.triangle,
                size: AppDimensions.avatarXL,
                backgroundColor: AppColors.primaryFixed,
                iconColor: AppColors.primary,
                iconSize: AppDimensions.iconXL,
                borderRadius: AppDimensions.radiusLG,
              ),
              AppInfoChip(
                label: AppStrings.percentDone(topic.progressPercent.toInt()),
                backgroundColor: AppColors.secondaryContainer,
                textColor: AppColors.onSecondaryContainer,
                textStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
                horizontalPadding: AppDimensions.progressBarLG,
                verticalPadding: AppDimensions.chipPaddingVertical,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(topic.name, style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            topic.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
              height: AppDimensions.lineHeightDefault,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.completedOfFormulas(topic.completedFormulas, topic.totalFormulas),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.outline,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                AppStrings.nearlyThere,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          ProgressBar(
            percentage: topic.progressPercent,
            height: AppDimensions.progressBarMD,
            backgroundColor:
                AppColors.secondaryFixedDim.withValues(alpha: AppDimensions.opacityLight),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                AppLogger.debug('Continue Learning tapped',
                    tag: AppLogTags.geometryPage);
              },
              icon: const Text(AppStrings.continueLearning),
              label: const Icon(LucideIcons.arrowRight,
                  size: AppDimensions.iconMD),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingLG),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusXXL),
                ),
                textStyle: AppTextStyles.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTopicCard(dynamic topic) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.circle,
                size: AppDimensions.avatarLG,
                backgroundColor: AppColors.tertiaryFixed,
                iconColor: AppColors.tertiary,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.name, style: AppTextStyles.titleLarge),
                    Text(
                      topic.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(
            percentage: topic.progressPercent,
            barColor: AppColors.primary,
            backgroundColor: AppColors.surfaceContainerHighest,
            height: AppDimensions.progressBarSM,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${topic.completedFormulas}/${topic.totalFormulas} ${AppStrings.formulasLabel}',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppLogger.debug(
                    'Start Now tapped: Circles',
                    tag: AppLogTags.geometryPage,
                  );
                },
                child: Text(
                  AppStrings.startNow.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuadrilateralsCard(dynamic topic) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.square,
                size: AppDimensions.avatarLG,
                backgroundColor: AppColors.orange100,
                iconColor: AppColors.orange600,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.name, style: AppTextStyles.titleLarge),
                    Text(
                      topic.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          ProgressBar(
            percentage: topic.progressPercent,
            barColor: AppColors.orange400,
            backgroundColor: AppColors.surfaceContainerHighest,
            height: AppDimensions.progressBarSM,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${topic.completedFormulas}/${topic.totalFormulas} ${AppStrings.formulasLabel}',
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.outline,
                ),
              ),
              GestureDetector(
                onTap: () {
                  AppLogger.debug(
                    'Start Now tapped: Quadrilaterals',
                    tag: AppLogTags.geometryPage,
                  );
                },
                child: Text(
                  AppStrings.startNow.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatesCard(dynamic topic) {
    return AppCard(
      color: AppColors.surfaceContainerHigh,
      border: Border.all(color: AppColors.white.withValues(alpha: AppDimensions.opacityMediumLight)),
      boxShadow: const [],
      child: Column(
        children: [
          Row(
            children: [
              AppIconCircle(
                icon: Icons.grid_on,
                size: AppDimensions.avatarLG,
                backgroundColor: AppColors.white,
                iconColor: AppColors.onSurfaceVariant,
                iconSize: AppDimensions.iconLG,
                borderRadius: AppDimensions.radiusMD,
                boxShadow: const [AppShadows.subtle],
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.name, style: AppTextStyles.titleLarge),
                    Text(
                      topic.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildSmallAvatar('XY', AppColors.blue200),
                  Transform.translate(
                    offset: const Offset(AppDimensions.avatarOverlapOffset, 0),
                    child: _buildSmallAvatar('D', AppColors.green200),
                  ),
                ],
              ),
              AppActionRow(
                label: AppStrings.viewTopics,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAvatar(String label, Color color) {
    return Container(
      width: AppDimensions.avatarSM,
      height: AppDimensions.avatarSM,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
            color: AppColors.white, width: AppDimensions.borderWidth),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: AppDimensions.fontSizeXXS,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedCard(dynamic topic) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: AppDimensions.opacitySubtle),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.tertiaryFixedDim.withValues(alpha: AppDimensions.opacityLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic.name,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            topic.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onTertiaryContainer.withValues(alpha: AppDimensions.opacityHigh),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            children: [
              AppInfoChip(
                label: AppStrings.locked,
                backgroundColor: AppColors.white.withValues(alpha: AppDimensions.opacityMediumLight),
                textColor: AppColors.tertiary,
                textStyle: AppTextStyles.overline.copyWith(
                  color: AppColors.tertiary,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              const Icon(LucideIcons.lock,
                  size: AppDimensions.iconSM, color: AppColors.tertiary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasteryTools() {
    final tools = [
      _MasteryTool(
        icon: LucideIcons.graduationCap,
        label: AppStrings.videoLessons,
        color: AppColors.primary,
      ),
      _MasteryTool(
        icon: LucideIcons.helpCircle,
        label: AppStrings.practiceQuiz,
        color: AppColors.secondary,
      ),
      _MasteryTool(
        icon: LucideIcons.fileText,
        label: AppStrings.cheatSheets,
        color: AppColors.orange500,
      ),
      _MasteryTool(
        icon: LucideIcons.box,
        label: AppStrings.visualizer3d,
        color: AppColors.tertiary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: AppStrings.masteryTools,
          leadingIcon: LucideIcons.sparkles,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AppDimensions.masteryToolsCrossAxisCount,
            mainAxisSpacing: AppDimensions.masteryToolsSpacing,
            crossAxisSpacing: AppDimensions.masteryToolsSpacing,
            childAspectRatio: AppDimensions.masteryToolsAspectRatio,
          ),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return AppCard(
              color: AppColors.white,
              boxShadow: const [AppShadows.subtle],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tool.icon,
                      size: AppDimensions.iconXXL, color: tool.color),
                  const SizedBox(height: AppDimensions.paddingSM),
                  Text(
                    tool.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MasteryTool {
  final IconData icon;
  final String label;
  final Color color;

  const _MasteryTool({
    required this.icon,
    required this.label,
    required this.color,
  });
}
