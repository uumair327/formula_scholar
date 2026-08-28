import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

class LocalizationSectionCard extends StatelessWidget {
  const LocalizationSectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppGlassCard(
      borderRadius: AppDimensions.radiusLG,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          if (child is! SizedBox) ...[
            const SizedBox(height: AppDimensions.paddingXL),
            child,
          ],
        ],
      ),
    );
  }
}
