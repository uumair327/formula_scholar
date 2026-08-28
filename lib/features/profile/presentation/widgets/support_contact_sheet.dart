import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

/// Bottom sheet for support contact actions.
class SupportContactSheet extends StatelessWidget {
  const SupportContactSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.email,
  });
  final String title;
  final String subtitle;
  final String email;

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String email,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          SupportContactSheet(title: title, subtitle: subtitle, email: email),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL),
          topRight: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: AppDimensions.avatarMD,
                height: AppDimensions.borderWidthThick,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            Row(
              children: [
                AppIconCircle(
                  icon: LucideIcons.messageCircle,
                  size: AppDimensions.avatarHero,
                  backgroundColor: colorScheme.primaryContainer,
                  iconColor: colorScheme.primary,
                  iconSize: AppDimensions.iconXL,
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXS),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            AppCard(
              border: Border.all(color: colorScheme.surfaceContainerHigh),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.mail,
                    color: colorScheme.primary,
                    size: AppDimensions.iconMD,
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Text(
                      email,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: email));
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(context.l10n.copiedEmail(email))));
                    },
                    child: Text(context.l10n.copyAction),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            AppCard(
              color: AppColors.primaryFixed.withValues(
                alpha: AppDimensions.opacityLight,
              ),
              border: Border.all(color: AppColors.primaryFixed),
              child: Text(
                'If you are blocked anywhere in the app, use the FAQ section first and then contact support with the exact screen name.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(context.l10n.doneAction),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
          ],
        ),
      ),
    );
  }
}
