import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class AnalyticsStatBox extends StatelessWidget {
  const AnalyticsStatBox({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = color ?? colorScheme.primary;

    // Extract number from value (e.g., "12%" -> 12, "1,000" -> 1000)
    final numMatch = RegExp(r'[\d,\.]+').firstMatch(value);
    final isPercentage = value.endsWith('%');
    final double targetNumber = numMatch != null
        ? double.tryParse(numMatch.group(0)!.replaceAll(',', '')) ?? 0.0
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingMD,
        horizontal: AppDimensions.paddingSM,
      ),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 24),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetNumber),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutQuart,
            builder: (context, current, child) {
              final displayNum = current.toInt();
              final displayStr = isPercentage ? '$displayNum%' : '$displayNum';
              // Fallback to original string if no number was parsed
              final finalText = numMatch != null ? displayStr : value;

              return Text(
                finalText,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
