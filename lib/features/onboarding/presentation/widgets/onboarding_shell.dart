import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

/// Shared layout shell for all 4 onboarding steps.
///
/// Provides the frosted-glass app-bar, step counter, animated
/// progress bar, scrollable body, and fixed bottom nav buttons.
/// Each step page only needs to supply [body], [currentStep],
/// [onBack], and [onContinue] — keeping step files small.
class OnboardingShell extends StatelessWidget {

  const OnboardingShell({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.body,
    required this.continueLabel,
    this.onContinue,
    this.onBack,
    this.isLoading = false,
  });
  final int currentStep;
  final int totalSteps;
  final Widget body;
  final VoidCallback? onBack;
  final String continueLabel;
  final VoidCallback? onContinue;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Frosted-glass app bar ──
          _OnboardingAppBar(currentStep: currentStep, totalSteps: totalSteps),
          // ── Progress bar ──
          _OnboardingProgressBar(progress: currentStep / totalSteps),
          // ── Scrollable body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingXL,
                AppDimensions.paddingLG,
                AppDimensions.paddingXL,
                AppDimensions.paddingHero * 2,
              ),
              child: body,
            ),
          ),
        ],
      ),
      // ── Fixed bottom nav ──
      bottomNavigationBar: _OnboardingBottomNav(
        onBack: onBack,
        continueLabel: continueLabel,
        onContinue: onContinue,
        isLoading: isLoading,
      ),
    );
  }
}

// ── App bar ──────────────────────────────────────────────────────────

class _OnboardingAppBar extends StatelessWidget {

  const _OnboardingAppBar({
    required this.currentStep,
    required this.totalSteps,
  });
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingMD,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
              ).createShader(bounds),
              child: Text(
                AppStrings.onboardingAppBrand,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(
              AppStrings.onboardingStepOf(currentStep, totalSteps),
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────

class _OnboardingProgressBar extends StatelessWidget {

  const _OnboardingProgressBar({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: AppDimensions.progressBarSM,
          backgroundColor: AppColors.surfaceContainer,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),
      ),
    );
  }
}

// ── Bottom nav ────────────────────────────────────────────────────────

class _OnboardingBottomNav extends StatelessWidget {

  const _OnboardingBottomNav({
    required this.onBack,
    required this.continueLabel,
    this.onContinue,
    required this.isLoading,
  });
  final VoidCallback? onBack;
  final String continueLabel;
  final VoidCallback? onContinue;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingLG,
        ),
        child: Row(
          children: [
            if (onBack != null) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingLG,
                    ),
                    shape: const StadiumBorder(),
                    foregroundColor: AppColors.onSurface,
                    backgroundColor: AppColors.surfaceContainer,
                    side: BorderSide.none,
                  ),
                  child: Text(
                    AppStrings.onboardingBack,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
            ],
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: isLoading ? null : onContinue,
                icon: isLoading
                    ? const SizedBox(
                        width: AppDimensions.iconSM,
                        height: AppDimensions.iconSM,
                        child: CircularProgressIndicator(
                          strokeWidth: AppDimensions.borderWidth,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : const Icon(LucideIcons.chevronRight),
                label: Text(continueLabel),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingLG,
                  ),
                  shape: const StadiumBorder(),
                  textStyle: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                  elevation: AppDimensions.elevationMD,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared step heading ───────────────────────────────────────────────

/// Displays tag, title, and optional subtitle for each onboarding step.
class OnboardingStepHeading extends StatelessWidget {

  const OnboardingStepHeading({
    super.key,
    required this.tag,
    required this.title,
    this.subtitle,
  });
  final String tag;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: AppDimensions.letterSpacingWide,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: AppDimensions.letterSpacingTight,
            height: AppDimensions.lineHeightTight,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            subtitle!,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// A selectable card used in onboarding step 2, 3, 4.
class OnboardingSelectCard extends StatelessWidget {

  const OnboardingSelectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

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
                icon,
                const SizedBox(height: AppDimensions.paddingXL),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  subtitle,
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  child: const Icon(
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
