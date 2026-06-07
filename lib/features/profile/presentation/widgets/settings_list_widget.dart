import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Settings list widget – premium styled options with icons, toggles, and actions.
class SettingsListWidget extends StatelessWidget {
  const SettingsListWidget({
    super.key,
    required this.items,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    required this.onItemTapped,
    this.startIndex = 11, // Default to 11 to continue from AccountInformationPage
    this.title,
  });

  final List<SettingsItem> items;
  final bool isDarkMode;
  final VoidCallback onDarkModeToggle;
  final ValueChanged<String> onItemTapped;
  final int startIndex;
  final String? title;

  (IconData, Color) _getIconAndColor(BuildContext context, String id) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (id) {
      'account' => (LucideIcons.user, AppColors.primary),
      'bookmarks' => (LucideIcons.bookmark, AppColors.secondary),
      'study_planner' => (LucideIcons.calendar, AppColors.primary),
      'achievements' => (LucideIcons.trophy, AppColors.orange500),
      'notifications' => (LucideIcons.bell, AppColors.primary),
      'language' => (LucideIcons.globe, colorScheme.outline),
      'appearance' => (LucideIcons.palette, AppColors.secondary),
      'help' => (LucideIcons.helpCircle, AppColors.tertiary),
      'about' => (LucideIcons.info, AppColors.primary),
      'change_password' => (LucideIcons.lock, AppColors.primary),
      'logout' => (Icons.logout, AppColors.error),
      'delete_account' => (LucideIcons.trash2, AppColors.error),
      _ => (LucideIcons.settings, colorScheme.outline),
    };
  }

  String _resolveLabel(BuildContext context, String id, String fallback) {
    return switch (id) {
      'account' => context.l10n.accountInformation,
      'bookmarks' => context.l10n.myBookmarks,
      'study_planner' => context.l10n.studyPlanner,
      'achievements' => context.l10n.achievements,
      'notifications' => context.l10n.notifications,
      'language' => context.l10n.languageAndLocalization,
      'appearance' => context.l10n.appearance,
      'help' => context.l10n.helpAndSupport,
      'about' => context.l10n.aboutApp,
      'change_password' => context.l10n.changePassword,
      'logout' => context.l10n.logout,
      'delete_account' => context.l10n.deleteAccount,
      _ => fallback,
    };
  }

  String? _resolveSubtitle(BuildContext context, String id, String? fallback) {
    return switch (id) {
      'account' => null, 
      'study_planner' => context.l10n.studyPlannerSubtitle,
      'achievements' => context.l10n.achievementsDesc,
      'language' => context.l10n.languageAndLocalizationSubtitle,
      'appearance' => context.l10n.toggleDarkMode,
      'about' => context.l10n.aboutAppSubtitle,
      'change_password' => null,
      'delete_account' => null,
      _ => fallback,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          EntranceWrapper.stagger(
            index: startIndex,
            child: AppSectionTitle(title: title!),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
        ],
        Column(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return EntranceWrapper.stagger(
              index: startIndex + 1 + index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
                child: _buildSettingsItem(context, item),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, SettingsItem item) {
    if (item.isToggle) {
      return _buildToggleItem(context, item);
    }
    return _buildNavigationItem(context, item);
  }

  Widget _buildNavigationItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, color) = _getIconAndColor(context, item.id);
    final label = _resolveLabel(context, item.id, item.label);
    final subtitle = _resolveSubtitle(context, item.id, item.subtitle);

    return AppCard(
      boxShadow: const [AppShadows.subtle],
      onTap: () {
        AppLogger.info(
          'Settings nav tapped: ${item.id}',
          tag: AppLogTags.settingsListWidget,
        );
        onItemTapped(item.id);
      },
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingLG,
      ),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: color.withValues(
              alpha: AppDimensions.opacityFaint,
            ),
            iconColor: color,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: item.isDestructive ? color : colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!item.isDestructive)
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? LucideIcons.chevronLeft
                  : LucideIcons.chevronRight,
              size: AppDimensions.iconMD,
              color: colorScheme.outlineVariant,
            ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final (icon, color) = _getIconAndColor(context, item.id);
    final label = _resolveLabel(context, item.id, item.label);
    final subtitle = _resolveSubtitle(context, item.id, item.subtitle);

    return AppCard(
      boxShadow: const [AppShadows.subtle],
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingMD,
      ),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: color.withValues(
              alpha: AppDimensions.opacityFaint,
            ),
            iconColor: color,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingXS),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value) => onDarkModeToggle(),
            activeTrackColor: color.withValues(alpha: 0.5),
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }
}
