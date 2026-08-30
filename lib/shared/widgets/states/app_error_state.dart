import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/core.dart';
import '../app_mascot.dart';
import '../mascot_painter.dart';
import '../mascot_speech_bubble.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel,
    this.icon = LucideIcons.alertTriangle,
  });

  final String? message;
  final VoidCallback onRetry;
  final String? retryLabel;
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
            const MascotSpeechBubble(message: 'Oops!'),
            const AppMascot(
              mood: MascotMood.sad,
              size: AppDimensions.mascotMD,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppText(
              context.l10n.somethingWentWrong,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            AppText(
              message ?? context.l10n.somethingWentWrong,
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
                label: AppText(
                  retryLabel ?? context.l10n.retry,
                  maxLines: 1,
                  softWrap: false,
                ),
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

