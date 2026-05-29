import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/widgets.dart';

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
          continueLabel: context.l10n.onboardingContinue,
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
              EntranceWrapper.stagger(
                index: 0,
                child: OnboardingStepHeading(
                  tag: context.l10n.step2Tag,
                  title: context.l10n.step2Title,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              if (state.status == OnboardingStatus.error)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.paddingLG,
                  ),
                  child: Text(
                    context.localizedError(
                      fallback:
                          state.errorMessage ??
                          'No boards available for this region',
                    ),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                )
              else if (state.boards.isEmpty &&
                  state.status != OnboardingStatus.loading)
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
                          children: state.boards.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final b = entry.value;
                            return SizedBox(
                              width:
                                  (constraints.maxWidth -
                                      AppDimensions.paddingLG) /
                                  2,
                              child: EntranceWrapper.stagger(
                                index: idx + 1,
                                child: CurriculumCard(
                                  board: b,
                                  isSelected: state.selectedBoard?.id == b.id,
                                  icon: _getIconForBoardType(b.type),
                                  color: _getColorForBoardType(context, b.type),
                                  onTap: () => context
                                      .read<OnboardingCubit>()
                                      .selectBoard(b),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: state.boards.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final b = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingLG,
                              ),
                              child: EntranceWrapper.stagger(
                                index: idx + 1,
                                child: CurriculumCard(
                                  board: b,
                                  isSelected: state.selectedBoard?.id == b.id,
                                  icon: _getIconForBoardType(b.type),
                                  color: _getColorForBoardType(context, b.type),
                                  onTap: () => context
                                      .read<OnboardingCubit>()
                                      .selectBoard(b),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // "Not sure" hint card
              EntranceWrapper.stagger(
                index: state.boards.length + 1,
                child: Container(
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
                              context.l10n.step2NotSureTitle,
                              style: AppTextStyles.labelLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingXXS),
                            Text(
                              context.l10n.step2NotSureDesc,
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
                        label: Text(context.l10n.step2LearnMore),
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
              ),
            ],
          ),
        );
      },
    );
  }
}
