import 'package:flutter/material.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

/// Settings list widget – account options with icons, toggles, and destructive actions.
///
/// Matches the React `SettingsList` component.
/// Maps domain `iconName` strings to Flutter `IconData` in the presentation layer,
/// keeping the domain layer free of framework dependencies.
class SettingsListWidget extends StatelessWidget {
  const SettingsListWidget({
    super.key,
    required this.items,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    required this.onItemTapped,
  });
  final List<SettingsItem> items;
  final bool isDarkMode;
  final VoidCallback onDarkModeToggle;
  final ValueChanged<String> onItemTapped;

  /// Maps domain icon name strings to Flutter `IconData`.
  static IconData _resolveIcon(String iconName) {
    return switch (iconName) {
      'person_outline' => Icons.person_outline,
      'bookmark_outline' => Icons.bookmark_outline,
      'notifications_outlined' => Icons.notifications_outlined,
      'language' => Icons.language,
      'palette_outlined' => Icons.palette_outlined,
      'help_outline' => Icons.help_outline,
      'info_outline' => Icons.info_outline,
      'logout' => Icons.logout,
      'emoji_events' => Icons.emoji_events,
      'calendar_today' => Icons.calendar_today,
      _ => Icons.settings,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(title: context.l10n.settings),
        const SizedBox(height: AppDimensions.paddingLG),
        Column(
          children: items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
              child: _buildSettingsItem(context, item),
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
    if (item.isDestructive) {
      return _buildDestructiveItem(context, item);
    }
    return _buildNavigationItem(context, item);
  }

  String _resolveLabel(BuildContext context, String id, String fallback) {
    return switch (id) {
      'account' => context.l10n.accountInformation,
      'bookmarks' => context.l10n.myBookmarks,
      'planner' => context.l10n.studyPlanner,
      'study_planner' => context.l10n.studyPlanner,
      'achievements' => context.l10n.achievements,
      'notifications' => context.l10n.notifications,
      'language' => context.l10n.languageAndLocalization,
      'appearance' => context.l10n.appearance,
      'help' => context.l10n.helpAndSupport,
      'about' => context.l10n.aboutApp,
      'logout' => context.l10n.logout,
      _ => fallback,
    };
  }

  String? _resolveSubtitle(BuildContext context, String id, String? fallback) {
    return switch (id) {
      'planner' => context.l10n.studyPlannerSubtitle,
      'study_planner' => context.l10n.studyPlannerSubtitle,
      'achievements' => context.l10n.achievementsDesc,
      'language' => context.l10n.languageAndLocalizationSubtitle,
      'appearance' => context.l10n.toggleDarkMode,
      'about' => context.l10n.aboutAppSubtitle,
      _ => fallback,
    };
  }

  Widget _buildNavigationItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _resolveIcon(item.iconName);
    return AppCard(
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
            backgroundColor: colorScheme.surfaceContainerHigh,
            iconColor: colorScheme.outline,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Text(_resolveLabel(context, item.id, item.label), style: AppTextStyles.labelLarge),
          ),
          Icon(
            Directionality.of(context) == TextDirection.rtl
                ? Icons.chevron_left
                : Icons.chevron_right,
            color: colorScheme.outlineVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _resolveIcon(item.iconName);
    
    final label = _resolveLabel(context, item.id, item.label);
    final subtitle = _resolveSubtitle(context, item.id, item.subtitle);

    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingMD,
      ),
      child: Row(
        children: [
          AppIconCircle(
            icon: icon,
            backgroundColor: colorScheme.surfaceContainerHigh,
            iconColor: colorScheme.outline,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                if (subtitle != null) ...[
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
          ),
        ],
      ),
    );
  }

  Widget _buildDestructiveItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _resolveIcon(item.iconName);
    return AppCard(
      onTap: () {
        AppLogger.warning(
          'Logout tapped',
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
            backgroundColor: AppColors.errorContainer.withValues(
              alpha: AppDimensions.opacityLight,
            ),
            iconColor: AppColors.error,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Text(
              _resolveLabel(context, item.id, item.label),
              style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
