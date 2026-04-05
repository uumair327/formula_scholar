import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_shell.dart';

/// Onboarding Step 3 — Grade selection.
/// Driven dynamically by OnboardingCubit based on the chosen Board.
class OnboardingStep3Page extends StatelessWidget {
  const OnboardingStep3Page({super.key});

  void _onContinue(BuildContext context) {
    context.go(AppRoutes.onboardingStep4Path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        if (state.status == OnboardingStatus.loading && state.grades.isEmpty) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return OnboardingShell(
          currentStep: 3,
          totalSteps: 4,
          continueLabel: AppStrings.onboardingContinue,
          onBack: () {
            context.read<OnboardingCubit>().goBackToBoards();
            context.go(AppRoutes.onboardingStep2Path);
          },
          onContinue: state.selectedGrade != null ? () => _onContinue(context) : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OnboardingStepHeading(
                tag: 'GRADE',
                title: 'Select Your Class',
                subtitle: 'Choose your academic year',
              ),
              const SizedBox(height: AppDimensions.paddingXXL),

              if (state.grades.isEmpty)
                Text('No grades available for this board.', style: AppTextStyles.bodyMedium),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 500;
                  return isWide
                      ? Wrap(
                          spacing: AppDimensions.paddingLG,
                          runSpacing: AppDimensions.paddingLG,
                          children: state.grades.map((g) {
                            return SizedBox(
                              width: (constraints.maxWidth - AppDimensions.paddingLG) / 2,
                              child: _GradeCard(
                                grade: g,
                                isSelected: state.selectedGrade?.id == g.id,
                                onTap: () => context.read<OnboardingCubit>().selectGrade(g),
                              ),
                            );
                          }).toList(),
                        )
                      : Column(
                          children: state.grades.map((g) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
                              child: _GradeCard(
                                grade: g,
                                isSelected: state.selectedGrade?.id == g.id,
                                onTap: () => context.read<OnboardingCubit>().selectGrade(g),
                              ),
                            );
                          }).toList(),
                        );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GradeCard extends StatelessWidget {
  final Grade grade;
  final bool isSelected;
  final VoidCallback onTap;

  const _GradeCard({
    required this.grade,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: AppDimensions.opacityMedium)
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
                        ? AppColors.primary
                        : AppColors.primary.withValues(
                            alpha: AppDimensions.opacityFaint,
                          ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: Icon(
                    LucideIcons.graduationCap,
                    size: AppDimensions.iconLG,
                    color: isSelected ? AppColors.onPrimary : AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  grade.label,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  'Grade ${grade.classNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onSurfaceVariant,
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: Icon(
                    LucideIcons.check,
                    size: AppDimensions.iconSM,
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
