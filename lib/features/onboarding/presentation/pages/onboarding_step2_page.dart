import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_board_guide_sheet.dart';
import '../widgets/onboarding_shell.dart';

/// Onboarding Step 2 — Curriculum / Board selection.
/// Driven dynamically by OnboardingCubit based on the chosen Country/State.
class OnboardingStep2Page extends StatelessWidget {
  const OnboardingStep2Page({super.key});

  void _onContinue(BuildContext context) {
    context.go(AppRoutes.onboardingStep3Path);
  }

  IconData _getIconForBoardType(BoardType type) {
    return switch (type) {
      BoardType.state => LucideIcons.school,
      BoardType.national => LucideIcons.landmark,
      BoardType.private => LucideIcons.globe,
      BoardType.examination => LucideIcons.bookOpen,
    };
  }

  Color _getColorForBoardType(BuildContext context, BoardType type) {
    final cs = Theme.of(context).colorScheme;
    return switch (type) {
      BoardType.state => cs.primary,
      BoardType.national => cs.primary,
      BoardType.private => cs.secondary,
      BoardType.examination => cs.tertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.boards != curr.boards ||
          prev.selectedBoard != curr.selectedBoard,
      builder: (context, state) {
        if (state.status == OnboardingStatus.loading && state.boards.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return OnboardingShell(
          currentStep: 2,
          totalSteps: 4,
          continueLabel: AppStrings.onboardingContinue,
          onBack: () {
            context.read<OnboardingCubit>().goBackToLocationSelection();
            context.go(AppRoutes.onboardingPath);
          },
          onContinue: state.selectedBoard != null
              ? () => _onContinue(context)
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const OnboardingStepHeading(
                tag: AppStrings.step2Tag,
                title: AppStrings.step2Title,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              if (state.status == OnboardingStatus.error)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
                  child: Text(
                    state.errorMessage ?? 'No boards available for this region',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                )
              else if (state.boards.isEmpty && state.status != OnboardingStatus.loading)
                Text(
                  'No boards available for this region',
                  style: AppTextStyles.bodyMedium,
                ),

              // Curriculum grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 500;
                  return isWide
                      ? Wrap(
                          spacing: AppDimensions.paddingLG,
                          runSpacing: AppDimensions.paddingLG,
                          children: state.boards.map((b) {
                            return SizedBox(
                              width:
                                  (constraints.maxWidth -
                                      AppDimensions.paddingLG) /
                                  2,
                              child: _CurriculumCard(
                                board: b,
                                isSelected: state.selectedBoard?.id == b.id,
                                icon: _getIconForBoardType(b.type),
                                color: _getColorForBoardType(context, b.type),
                                onTap: () => context
                                    .read<OnboardingCubit>()
                                    .selectBoard(b),
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: state.boards.map((b) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingLG,
                              ),
                              child: _CurriculumCard(
                                board: b,
                                isSelected: state.selectedBoard?.id == b.id,
                                icon: _getIconForBoardType(b.type),
                                color: _getColorForBoardType(context, b.type),
                                onTap: () => context
                                    .read<OnboardingCubit>()
                                    .selectBoard(b),
                              ),
                            );
                          }).toList(),
                        );
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // "Not sure" hint card
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.step2NotSureTitle,
                            style: AppTextStyles.labelLarge.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingXXS),
                          Text(
                            AppStrings.step2NotSureDesc,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMD),
                    TextButton.icon(
                      onPressed: () => OnboardingBoardGuideSheet.show(
                        context,
                        boards: state.boards,
                        selectedBoardId: state.selectedBoard?.id,
                        onSelectBoard: (board) =>
                            context.read<OnboardingCubit>().selectBoard(board),
                      ),
                      icon: const Icon(
                        LucideIcons.arrowRight,
                        size: AppDimensions.iconSM,
                      ),
                      label: const Text(AppStrings.step2LearnMore),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CurriculumCard extends StatelessWidget {
  const _CurriculumCard({
    required this.board,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
  });
  final Board board;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(
                    alpha: AppDimensions.opacityMedium,
                  )
                : AppColors.transparent,
            width: isSelected
                ? AppDimensions.borderWidthThick
                : AppDimensions.borderWidth,
          ),
          boxShadow: isSelected ? [AppShadows.ghost] : [AppShadows.subtle],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: AppDurations.animationFast,
                  width: AppDimensions.avatarLG,
                  height: AppDimensions.avatarLG,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color
                        : color.withValues(alpha: AppDimensions.opacityFaint),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.iconLG,
                    color: isSelected ? AppColors.onPrimary : color,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  board.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  board.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: AppDimensions.iconMD,
                  height: AppDimensions.iconMD,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
                    LucideIcons.checkCircle2,
                    size: AppDimensions.iconDefault,
                    color: AppColors.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
