import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../widgets/support_contact_sheet.dart';

class HelpQuickActions extends StatelessWidget {
  const HelpQuickActions({super.key, required this.onFaqTap});

  final VoidCallback onFaqTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            icon: LucideIcons.messageCircle,
            label: context.l10n.chatWithUs,
            color: AppColors.primary,
            bgColor: AppColors.primaryFixed,
            onTap: () => ComingSoonSheet.show(
              context,
              featureName: context.l10n.chatWithUs,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMD),
        Expanded(
          child: _QuickActionTile(
            icon: LucideIcons.mail,
            label: context.l10n.emailUs,
            color: AppColors.secondary,
            bgColor: AppColors.secondaryFixed,
            onTap: () => SupportContactSheet.show(
              context,
              title: context.l10n.emailUs,
              subtitle: '',
              email: 'support@formulascholar.app',
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMD),
        Expanded(
          child: _QuickActionTile(
            icon: LucideIcons.fileQuestion,
            label: context.l10n.faqLabel,
            color: AppColors.tertiary,
            bgColor: AppColors.tertiaryFixed,
            onTap: onFaqTap,
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AppCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingXL,
            horizontal: AppDimensions.paddingSM,
          ),
          child: Column(
            children: [
              Container(
                width: AppDimensions.avatarLG,
                height: AppDimensions.avatarLG,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppDimensions.iconLG, color: color),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
