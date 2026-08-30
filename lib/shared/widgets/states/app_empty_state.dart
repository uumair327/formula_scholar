import 'package:flutter/material.dart';

import '../../../core/core.dart';
import '../app_mascot.dart';
import '../mascot_painter.dart';
import '../mascot_speech_bubble.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.mascotMessage,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Optional message shown in a speech bubble above the mascot.
  final String? mascotMessage;

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
            if (mascotMessage != null)
              MascotSpeechBubble(message: mascotMessage!),
            const AppMascot(
              mood: MascotMood.sad,
              size: AppDimensions.mascotMD,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppText(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            if (description != null) ...[
              const SizedBox(height: AppDimensions.paddingSM),
              AppText(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: AppDimensions.lineHeightRelaxed,
                ),
                maxLines: 3,
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
                child: AppText(actionLabel!, maxLines: 1, softWrap: false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

