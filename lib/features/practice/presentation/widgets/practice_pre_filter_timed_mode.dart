import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class PreFilterTimedModeCard extends StatelessWidget {
  const PreFilterTimedModeCard({
    super.key,
    required this.isTimed,
    required this.timedDuration,
    required this.onTimedChanged,
    required this.onDurationChanged,
  });

  final bool isTimed;
  final int? timedDuration;
  final ValueChanged<bool> onTimedChanged;
  final ValueChanged<int?> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          child: Row(
            children: [
              AppIconCircle(
                icon: LucideIcons.timer,
                backgroundColor: colorScheme.primaryContainer,
                iconColor: colorScheme.primary,
                size: 40,
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.timedMode,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      context.l10n.timedModeDesc,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isTimed,
                onChanged: (v) {
                  HapticsHelper.lightImpact();
                  onTimedChanged(v);
                  if (!v) onDurationChanged(null);
                },
              ),
            ],
          ),
        ),
        AnimatedSize(
          duration: AppDurations.animationFast,
          curve: Curves.easeOutCubic,
          child: !isTimed
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.paddingSM),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.duration,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        Wrap(
                          spacing: AppDimensions.paddingSM,
                          runSpacing: AppDimensions.paddingSM,
                          children: [5, 10, 15, 30, 60].map((mins) {
                            final isSelected = timedDuration == mins * 60;
                            return AppCard(
                              onTap: () {
                                HapticsHelper.selectionClick();
                                onDurationChanged(mins * 60);
                              },
                              borderRadius: AppDimensions.radiusLG,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingMD,
                                vertical: AppDimensions.paddingSM,
                              ),
                              color: isSelected
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.5),
                              boxShadow: const [],
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.primary
                                    : Colors.transparent,
                              ),
                              child: Text(
                                '$mins min',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

