import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../support_contact_sheet.dart';

class AccountActionTile extends StatelessWidget {
  const AccountActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap ?? () => SupportContactSheet.show(
        context,
        title: label,
        subtitle: 'This account action is being expanded. Contact support and we will help you right away.',
        email: 'support@formulascholar.app',
      ),
      boxShadow: const [AppShadows.subtle],
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL, vertical: AppDimensions.paddingLG),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: color.withValues(alpha: AppDimensions.opacityFaint),
            iconColor: color,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Text(label, style: AppTextStyles.labelLarge.copyWith(color: color, fontWeight: FontWeight.w700)),
          ),
          Icon(
            Directionality.of(context) == TextDirection.rtl
                ? LucideIcons.chevronLeft
                : LucideIcons.chevronRight,
            size: AppDimensions.iconMD,
            color: color.withValues(alpha: AppDimensions.opacityMedium),
          ),
        ],
      ),
    );
  }
}
