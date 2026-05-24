library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class MasteryToggleButton extends StatelessWidget {
  const MasteryToggleButton({
    super.key,
    required this.isMastered,
    required this.onToggle,
  });

  final bool isMastered;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isMastered
          ? AppColors.secondaryFixed
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: InkWell(
        onTap: () {
          HapticsHelper.mediumImpact();
          onToggle();
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curveDefault,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isMastered ? LucideIcons.checkCircle2 : LucideIcons.circle,
                size: AppDimensions.iconMD,
                color: isMastered
                    ? AppColors.secondary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                isMastered ? 'Mastered' : 'Mark as Mastered',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isMastered
                      ? AppColors.secondary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
