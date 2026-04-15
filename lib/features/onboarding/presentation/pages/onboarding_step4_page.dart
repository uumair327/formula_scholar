import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_shell.dart';

/// Onboarding Step 4 — Weekly study goal selection.
///
/// User picks from: Casual Learner (15 min/day), Regular Scholar
/// (30 min/day), or Intensive Mastery (60+ min/day).
/// On "Enter Sanctuary" it navigates to the dashboard.
///
/// Design based on OnboardingStep4.tsx.
class OnboardingStep4Page extends StatefulWidget {
  const OnboardingStep4Page({super.key});

  @override
  State<OnboardingStep4Page> createState() => _OnboardingStep4PageState();
}

class _OnboardingStep4PageState extends State<OnboardingStep4Page> {
  static const List<_GoalOption> _goals = [
    _GoalOption(
      id: 'casual',
      icon: LucideIcons.target,
      title: AppStrings.step4Casual,
      subtitle: AppStrings.step4CasualDesc,
      color: Color(0xFF056C42),
    ),
    _GoalOption(
      id: 'regular',
      icon: LucideIcons.flame,
      title: AppStrings.step4Regular,
      subtitle: AppStrings.step4RegularDesc,
      color: Color(0xFF00639A),
    ),
    _GoalOption(
      id: 'intensive',
      icon: LucideIcons.zap,
      title: AppStrings.step4Intensive,
      subtitle: AppStrings.step4IntensiveDesc,
      color: Color(0xFF655781),
    ),
  ];

  String _selectedId = 'regular';

  Future<void> _onFinish() async {
    final onboardingCubit = context.read<OnboardingCubit>();
    final curriculum = await onboardingCubit.completeOnboarding(_selectedId);
    if (!mounted) {
      return;
    }

    if (curriculum != null) {
      context.read<CurriculumCubit>().applyCurriculum(curriculum);
      context.go(AppRoutes.dashboardPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingShell(
      currentStep: 4,
      totalSteps: 4,
      continueLabel: AppStrings.step4EnterSanctuary,
      onBack: () => context.go(AppRoutes.onboardingStep3Path),
      onContinue: () {
        _onFinish();
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingStepHeading(
            tag: AppStrings.step4Tag,
            title: AppStrings.step4Title,
            subtitle: AppStrings.step4Subtitle,
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Column(
            children: _goals.map((goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
                child: _GoalCard(
                  goal: goal,
                  isSelected: _selectedId == goal.id,
                  onTap: () => setState(() => _selectedId = goal.id),
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
  final _GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? goal.color.withValues(alpha: AppDimensions.opacityMedium)
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
                    ? goal.color
                    : goal.color.withValues(alpha: AppDimensions.opacityFaint),
              ),
              child: Icon(
                goal.icon,
                size: AppDimensions.iconDefault,
                color: isSelected ? AppColors.onPrimary : goal.color,
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
                      color: AppColors.onSurfaceVariant,
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
                  color: goal.color,
                ),
                child: Icon(
                  LucideIcons.check,
                  size: AppDimensions.iconSM,
                  color: AppColors.onPrimary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GoalOption {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _GoalOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}
