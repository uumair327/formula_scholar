import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
            Text(
              AppStrings.onboardingStepOf(currentStep, totalSteps),
              style: AppTextStyles.labelMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
        child: SizedBox(
          height: AppDimensions.progressBarSM,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? AppColors.darkPrimaryGradient
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                  ),
                ),
              ),
            ],
          ),
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
    final colorScheme = Theme.of(context).colorScheme;

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
                    foregroundColor: colorScheme.onSurface,
                    backgroundColor: colorScheme.surfaceContainer,
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
              child: AppGradientButton(
                label: continueLabel,
                onPressed: isLoading ? null : onContinue,
                isLoading: isLoading,
                icon: LucideIcons.chevronRight,
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
    final colorScheme = Theme.of(context).colorScheme;

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
              color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.animationFast,
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.darkPrimary.withValues(alpha: 0.08)
                  : AppColors.primaryFixed.withValues(alpha: 0.08))
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(
                    alpha: AppDimensions.opacityMedium,
                  )
                : colorScheme.surfaceContainerHigh.withValues(
                    alpha: AppDimensions.opacitySubtle,
                  ),
            width: isSelected
                ? AppDimensions.borderWidthThick
                : AppDimensions.borderWidth,
          ),
          boxShadow: isSelected
              ? [AppShadows.glow(AppColors.primary)]
              : const [AppShadows.subtle],
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isDark
                        ? AppColors.darkPrimaryGradient
                        : AppColors.primaryGradient,
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
