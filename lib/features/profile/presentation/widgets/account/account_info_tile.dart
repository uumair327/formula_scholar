import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';

class AccountInfoTile extends StatelessWidget {
  const AccountInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL, vertical: AppDimensions.paddingLG),
      child: Row(
        children: [
          AppIconCircle(icon: icon, backgroundColor: colorScheme.surfaceContainerHigh, iconColor: colorScheme.outline),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline, fontWeight: FontWeight.w600)),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(value, style: AppTextStyles.labelLarge.copyWith(color: valueColor ?? colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
