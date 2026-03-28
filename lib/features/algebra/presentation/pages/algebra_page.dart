import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/algebra_cubit.dart';
import '../cubit/algebra_state.dart';

/// Algebra cheat sheet page – formula cards grouped by section.
class AlgebraPage extends StatelessWidget {
  const AlgebraPage({super.key});

  static const _sectionDotColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  static const _cardBorderColors = [
    AppColors.primaryContainer,
    AppColors.secondaryContainer,
    AppColors.tertiaryContainer,
    AppColors.primary,
    AppColors.tertiaryFixedDim,
    AppColors.outlineVariant,
  ];

  static const _highlightColors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlgebraCubit, AlgebraState>(
      builder: (context, state) {
        if (state.status == AlgebraStatus.loading ||
            state.status == AlgebraStatus.initial) {
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
                    _buildHeaderSection(),
                    const SizedBox(height: AppDimensions.paddingXXL),
                    _buildFormulaSections(state),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildExamTip(),
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
      backgroundColor:
          AppColors.surfaceContainerLowest.withValues(alpha: AppDimensions.opacityAppBar),
      surfaceTintColor: AppColors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXS),
        child: AppAvatar(imageUrl: AppAssets.algebraAvatarUrl),
      ),
      title: Text(
        AppStrings.welcomeScholar,
        style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.onPrimaryFixedVariant),
      ),
      actions: [
        IconButton(
          onPressed: () {
            AppLogger.debug('Search tapped', tag: AppLogTags.algebraPage);
          },
          icon: const Icon(LucideIcons.search, color: AppColors.primary),
        ),
        IconButton(
          onPressed: () {
            AppLogger.debug('Stats tapped', tag: AppLogTags.algebraPage);
          },
          icon:
              const Icon(LucideIcons.barChart3, color: AppColors.primary),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppInfoChip(
              label: AppStrings.mathStandard,
              backgroundColor: AppColors.primaryFixed.withValues(alpha: AppDimensions.opacityLight),
              textColor: AppColors.primary,
              textStyle: AppTextStyles.overline.copyWith(
                color: AppColors.primary,
              ),
            ),
            Row(
              children: [
                const Icon(LucideIcons.zap,
                    size: AppDimensions.iconSM,
                    color: AppColors.secondary),
                const SizedBox(width: AppDimensions.paddingXS),
                Text(
                  AppStrings.quickRevisionMode,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        Text(
          AppStrings.algebraCheatSheet,
          style: AppTextStyles.headlineLarge,
        ),
        const SizedBox(height: AppDimensions.paddingXL),
        _buildTabBar(),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSM - AppDimensions.paddingXXS),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        boxShadow: const [AppShadows.subtle],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingXS),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXL),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.progressBarMD),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXL),
                        boxShadow: const [AppShadows.subtle],
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.quickRevision,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimensions.progressBarMD),
                      child: Center(
                        child: Text(
                          AppStrings.detailedView,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSM),
          const AppIconCircle(
            icon: LucideIcons.search,
            size: AppDimensions.avatarMD,
            backgroundColor: AppColors.primary,
            iconColor: AppColors.onPrimary,
            iconSize: AppDimensions.iconMD,
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSections(AlgebraState state) {
    return Column(
      children: [
        for (int i = 0; i < state.sections.length; i++) ...[
          if (i > 0) const SizedBox(height: AppDimensions.paddingXXL),
          _buildSection(state.sections[i], i),
        ],
      ],
    );
  }

  Widget _buildSection(FormulaSection section, int sectionIndex) {
    final dotColor =
        _sectionDotColors[sectionIndex % _sectionDotColors.length];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSM),
          child: Row(
            children: [
              Container(
                width: AppDimensions.sectionDotSize,
                height: AppDimensions.sectionDotSize,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                section.title,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingMD),
        ...section.formulas.asMap().entries.map((entry) {
          final globalIndex = _getGlobalIndex(sectionIndex, entry.key);
          return Padding(
            padding:
                const EdgeInsets.only(bottom: AppDimensions.paddingMD),
            child: _buildFormulaCard(
              entry.value,
              globalIndex,
              sectionIndex,
            ),
          );
        }),
      ],
    );
  }

  int _getGlobalIndex(int sectionIndex, int formulaIndex) {
    int count = 0;
    for (int i = 0; i < sectionIndex; i++) {
      count += 3;
    }
    return count + formulaIndex;
  }

  Widget _buildFormulaCard(
    Formula formula,
    int globalIndex,
    int sectionIndex,
  ) {
    final borderColor =
        _cardBorderColors[globalIndex % _cardBorderColors.length];
    final highlightColor =
        _highlightColors[sectionIndex % _highlightColors.length];

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        boxShadow: const [AppShadows.subtle],
        border: Border(
          bottom: BorderSide(
              color: borderColor, width: AppDimensions.borderWidthThick),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (formula.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSM,
                        vertical: AppDimensions.paddingXXS),
                    decoration: BoxDecoration(
                      color: sectionIndex == 0
                          ? AppColors.onSecondaryContainer
                          : AppColors.onPrimaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusXS),
                    ),
                    child: Text(
                      formula.badge!,
                      style: AppTextStyles.overline.copyWith(
                        color: sectionIndex == 0
                            ? AppColors.secondaryContainer
                            : AppColors.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                ],
                if (formula.highlightedPart != null)
                  _buildHighlightedExpression(formula.expression,
                      formula.highlightedPart!, highlightColor)
                else
                  Text(
                    formula.expression,
                    style: AppTextStyles.headlineMedium.copyWith(
                      letterSpacing: AppDimensions.letterSpacingMediumTight,
                    ),
                  ),
                const SizedBox(height: AppDimensions.paddingMD),
                if (formula.tag != null)
                  Wrap(
                    spacing: AppDimensions.paddingSM,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSM,
                            vertical: AppDimensions.paddingXS),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryFixed,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSM),
                        ),
                        child: Text(
                          formula.tag!,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.onTertiaryFixedVariant,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      if (formula.description != null)
                        Text(
                          '• ${formula.description}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant
                                .withValues(alpha: AppDimensions.opacityMedium),
                          ),
                        ),
                    ],
                  )
                else if (formula.description != null)
                  Text(
                    formula.description!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: AppDimensions.lineHeightDefault,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSM),
          GestureDetector(
            onTap: () {
              AppLogger.debug(
                'Bookmark tapped: ${formula.id}',
                tag: AppLogTags.algebraPage,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: AppDimensions.paddingXXS),
              child: Icon(
                formula.isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                size: AppDimensions.iconLG,
                color: formula.isBookmarked
                    ? AppColors.primaryContainer
                    : AppColors.outlineVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedExpression(
    String full,
    String highlighted,
    Color highlightColor,
  ) {
    final parts = full.split(highlighted);
    return RichText(
      text: TextSpan(
        style: AppTextStyles.headlineMedium.copyWith(
          letterSpacing: AppDimensions.letterSpacingMediumTight,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: highlighted,
            style: TextStyle(color: highlightColor),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildExamTip() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.lightbulb,
                      size: AppDimensions.iconMD,
                      color: AppColors.onTertiaryContainer),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Text(
                    AppStrings.examTip,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.onTertiaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.examTipContent,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onTertiaryContainer
                      .withValues(alpha: AppDimensions.opacityNearOpaque),
                  height: AppDimensions.lineHeightDefault,
                ),
              ),
            ],
          ),
          Positioned(
            right: AppDimensions.decorativeOffset,
            bottom: AppDimensions.decorativeOffset,
            child: const Opacity(
              opacity: 0.1,
              child: Icon(
                LucideIcons.brain,
                size: AppDimensions.decorativeIconSize,
                color: AppColors.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
