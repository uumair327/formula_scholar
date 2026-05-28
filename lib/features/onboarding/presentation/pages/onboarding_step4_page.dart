import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/widgets.dart';

/// Onboarding Step 4 — Weekly study goal selection.
///
/// User picks from: Casual Learner (15 min/day), Regular Scholar
/// (30 min/day), or Intensive Mastery (60+ min/day).
/// On "Enter Sanctuary" it navigates to the dashboard.
///
/// Design based on OnboardingStep4.tsx.
class OnboardingStep4Page extends StatelessWidget {
  const OnboardingStep4Page({super.key});

  // Goals are built at runtime to allow localized labels via `context.l10n`.

  Future<void> _onFinish(BuildContext context) async {
    final onboardingCubit = context.read<OnboardingCubit>();
    final curriculum = await onboardingCubit.completeOnboarding();
    if (!context.mounted) {
      return;
    }

    if (curriculum != null) {
      context.read<CurriculumCubit>().applyCurriculum(curriculum);
      context.go(AppRoutes.dashboardPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final goals = [
      _GoalOption(
        id: 'casual',
        icon: LucideIcons.target,
        title: l10n.step4Casual,
        subtitle: l10n.step4CasualDesc,
      ),
      _GoalOption(
        id: 'regular',
        icon: LucideIcons.flame,
        title: l10n.step4Regular,
        subtitle: l10n.step4RegularDesc,
      ),
      _GoalOption(
        id: 'intensive',
        icon: LucideIcons.zap,
        title: l10n.step4Intensive,
        subtitle: l10n.step4IntensiveDesc,
      ),
    ];

    return OnboardingShell(
      currentStep: 4,
      totalSteps: 4,
      continueLabel: context.l10n.step4EnterSanctuary,
      onBack: () => context.go(AppRoutes.onboardingStep3Path),
      onContinue: () {
        _onFinish(context);
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeading(
            tag: context.l10n.step4Tag,
            title: context.l10n.step4Title,
            subtitle: context.l10n.step4Subtitle,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Column(
            children: goals.map((goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
                child: _GoalCard(
                  goal: goal,
                  isSelected: context.select<OnboardingCubit, bool>(
                    (cubit) => cubit.state.selectedStudyGoalId == goal.id,
                  ),
                  onTap: () =>
                      context.read<OnboardingCubit>().selectStudyGoal(goal.id),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });
  final _GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  Color _goalAccent(ColorScheme cs) {
    return switch (goal.id) {
      'casual' => cs.secondary,
      'regular' => cs.primary,
      'intensive' => cs.tertiary,
      _ => cs.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = _goalAccent(colorScheme);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? accent.withValues(alpha: AppDimensions.opacityMedium)
                : AppColors.transparent,
            width: isSelected
                ? AppDimensions.borderWidthThick
                : AppDimensions.borderWidth,
          ),
          boxShadow: isSelected ? [AppShadows.ghost] : [AppShadows.subtle],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: AppDurations.animationFast,
              width: AppDimensions.avatarMD,
              height: AppDimensions.avatarMD,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? accent
                    : accent.withValues(alpha: AppDimensions.opacityFaint),
              ),
              child: Icon(
                goal.icon,
                size: AppDimensions.iconDefault,
                color: isSelected ? colorScheme.onPrimary : accent,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    goal.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: AppDimensions.iconMD,
                height: AppDimensions.iconMD,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent,
                ),
                child: Icon(
                  LucideIcons.check,
                  size: AppDimensions.iconSM,
                  color: colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GoalOption {
  const _GoalOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
}
