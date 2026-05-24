import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/core.dart';
import '../app_text.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel = AppStrings.retry,
    this.icon = LucideIcons.alertTriangle,
  });

  final String? message;
  final VoidCallback onRetry;
  final String retryLabel;
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
            AppText(
              'Something went wrong',
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            AppText(
              message ?? AppStrings.somethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            SizedBox(
              width: 200,
              child: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(LucideIcons.refreshCw, size: 18),
                label: AppText(retryLabel, maxLines: 1, softWrap: false),
                style: FilledButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.darkPrimary
                      : colorScheme.primary,
                  foregroundColor: isDark
                      ? AppColors.darkOnPrimary
                      : colorScheme.onPrimary,
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
