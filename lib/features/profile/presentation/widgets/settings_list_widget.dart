import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

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
      'logout' => Icons.logout,
      'emoji_events' => Icons.emoji_events,
      _ => Icons.settings,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(title: AppStrings.settings),
        const SizedBox(height: AppDimensions.paddingLG),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            boxShadow: const [AppShadows.ghost],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final item = entry.value;
              final index = entry.key;
              final showTopDivider = _shouldShowDivider(index);

              return Column(
                children: [
                  if (showTopDivider)
                    Divider(
                      height: AppDimensions.dividerHeight,
                      color: colorScheme.surfaceContainer,
                    ),
                  _buildSettingsItem(context, item),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool _shouldShowDivider(int index) {
    if (index == 0) return false;
    final item = items[index];
    // Appearance and Logout have dividers before them
    return item.id == 'appearance' || item.id == 'logout';
  }

  Widget _buildSettingsItem(BuildContext context, SettingsItem item) {
    if (item.isToggle) {
      return _buildToggleItem(context, item);
    }
    if (item.isDestructive) {
      return _buildDestructiveItem(item);
    }
    return _buildNavigationItem(context, item);
  }

  Widget _buildNavigationItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
      child: Tooltip(
        message: item.label,
        child: InkWell(
          onTap: () {
            AppLogger.info(
              'Settings nav tapped: ${item.id}',
              tag: AppLogTags.settingsListWidget,
            );
            onItemTapped(item.id);
          },
          child: Padding(
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
                  child: Text(item.label, style: AppTextStyles.labelLarge),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left
                      : Icons.chevron_right,
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, SettingsItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
      child: Tooltip(
        message: item.label,
        child: InkWell(
          onTap: onDarkModeToggle,
          child: Padding(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.label, style: AppTextStyles.labelLarge),
                      if (item.subtitle != null)
                        Text(
                          item.subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.outline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                Semantics(
                  label: AppStrings.toggleDarkMode,
                  toggled: isDarkMode,
                  child: Switch.adaptive(
                    value: isDarkMode,
                    onChanged: (_) => onDarkModeToggle(),
                    activeThumbColor: AppColors.primary,
                    activeTrackColor: AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestructiveItem(SettingsItem item) {
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
      child: Tooltip(
        message: item.label,
        child: InkWell(
          onTap: () {
            AppLogger.warning(
              'Logout tapped',
              tag: AppLogTags.settingsListWidget,
            );
            onItemTapped(item.id);
          },
          splashColor: AppColors.errorContainer,
          child: Padding(
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
                    item.label,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
