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
  final List<SettingsItem> items;
  final bool isDarkMode;
  final VoidCallback onDarkModeToggle;
  final ValueChanged<String> onItemTapped;

  const SettingsListWidget({
    super.key,
    required this.items,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    required this.onItemTapped,
  });

  /// Maps domain icon name strings to Flutter `IconData`.
  static IconData _resolveIcon(String iconName) {
    return switch (iconName) {
      'person_outline' => Icons.person_outline,
      'bookmark_outline' => Icons.bookmark_outline,
      'notifications_outlined' => Icons.notifications_outlined,
      'palette_outlined' => Icons.palette_outlined,
      'help_outline' => Icons.help_outline,
      'logout' => Icons.logout,
      _ => Icons.settings,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(title: AppStrings.settings),
        const SizedBox(height: AppDimensions.paddingLG),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
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
                    const Divider(
                      height: AppDimensions.dividerHeight,
                      color: AppColors.surfaceContainer,
                    ),
                  _buildSettingsItem(item),
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

  Widget _buildSettingsItem(SettingsItem item) {
    if (item.isToggle) {
      return _buildToggleItem(item);
    }
    if (item.isDestructive) {
      return _buildDestructiveItem(item);
    }
    return _buildNavigationItem(item);
  }

  Widget _buildNavigationItem(SettingsItem item) {
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
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
                backgroundColor: AppColors.surfaceContainerHigh,
                iconColor: AppColors.outline,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Text(item.label, style: AppTextStyles.labelLarge),
              ),
              const Icon(Icons.chevron_right, color: AppColors.outlineVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(SettingsItem item) {
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
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
                backgroundColor: AppColors.surfaceContainerHigh,
                iconColor: AppColors.outline,
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
                          color: AppColors.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
              _buildCustomSwitch(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestructiveItem(SettingsItem item) {
    final icon = _resolveIcon(item.iconName);
    return Material(
      color: AppColors.transparent,
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
    );
  }

  Widget _buildCustomSwitch(bool value) {
    return AnimatedContainer(
      duration: AppDurations.animationFast,
      width: AppDimensions.switchWidth,
      height: AppDimensions.switchHeight,
      padding: const EdgeInsets.all(AppDimensions.switchPadding),
      decoration: BoxDecoration(
        color: value ? AppColors.primary : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.paddingMD),
      ),
      child: AnimatedAlign(
        duration: AppDurations.animationFast,
        curve: AppDurations.curveDefault,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: AppDimensions.switchThumbSize,
          height: AppDimensions.switchThumbSize,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [AppShadows.switchThumb],
          ),
        ),
      ),
    );
  }
}
