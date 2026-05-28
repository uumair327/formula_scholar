import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';

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
          _OnboardingAppBar(currentStep: currentStep, totalSteps: totalSteps),
          _OnboardingProgressBar(progress: currentStep / totalSteps),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(
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
      bottomNavigationBar: _OnboardingBottomNav(
        onBack: onBack,
        continueLabel: continueLabel,
        onContinue: onContinue,
        isLoading: isLoading,
      ),
    );
  }
}

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.onboardingAppBrand,
              style: AppTextStyles.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryContainer],
              ).createShader(bounds),
              child: Text(
                AppStrings.onboardingStepOf(currentStep, totalSteps),
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
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
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
                    context.l10n.onboardingBack,
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
                icon: Directionality.of(context) == TextDirection.rtl
                    ? LucideIcons.chevronLeft
                    : LucideIcons.chevronRight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
