import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// Branded error state widget with illustration and gradient retry button.
///
/// Replaces the duplicated error Scaffold pattern with a premium design.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel = AppStrings.retry,
    this.icon = LucideIcons.alertTriangle,
  });

  /// The error message to display. Falls back to [AppStrings.somethingWentWrong].
  final String? message;

  /// Callback when the retry button is pressed.
  final VoidCallback onRetry;

  /// Optional retry button label.
  final String retryLabel;

  /// Custom icon (defaults to alert triangle).
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSection,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorated icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.iconXL,
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Text(
              'Something went wrong',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              message ?? AppStrings.somethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            // Gradient retry button
            SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                label: Text(retryLabel),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.darkPrimary : colorScheme.primary,
                  foregroundColor:
                      isDark ? AppColors.darkOnPrimary : colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Branded empty state with illustration and optional CTA.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon = LucideIcons.inbox,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingSection,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Layered circle icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: AppDimensions.iconXXL,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: AppDimensions.lineHeightRelaxed,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppDimensions.paddingXXL),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXXL,
                    vertical: AppDimensions.paddingMD,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Reusable loading state widget with premium spinner.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              message!,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
