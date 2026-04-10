import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

/// Notifications settings page – manage notification preferences.
///
/// Accessible from profile settings. Shows toggle options for
/// different notification categories with premium styling.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Local state for notification toggles.
  bool _studyReminders = true;
  bool _streakAlerts = true;
  bool _newContent = false;
  bool _achievements = true;
  bool _weeklyReport = false;
  bool _pushNotifications = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingXXL),
                // Notification status card
                _buildStatusCard(),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Study notifications
                const AppSectionTitle(title: AppStrings.studyNotifications),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildToggleTile(
                  icon: LucideIcons.clock,
                  title: AppStrings.studyReminders,
                  subtitle: AppStrings.studyRemindersDesc,
                  value: _studyReminders,
                  onChanged: (v) => setState(() => _studyReminders = v),
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildToggleTile(
                  icon: LucideIcons.flame,
                  title: AppStrings.streakAlerts,
                  subtitle: AppStrings.streakAlertsDesc,
                  value: _streakAlerts,
                  onChanged: (v) => setState(() => _streakAlerts = v),
                  color: AppColors.orange500,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildToggleTile(
                  icon: LucideIcons.sparkles,
                  title: AppStrings.newContent,
                  subtitle: AppStrings.newContentDesc,
                  value: _newContent,
                  onChanged: (v) => setState(() => _newContent = v),
                  color: AppColors.secondary,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Achievement notifications 
                const AppSectionTitle(title: AppStrings.achievementNotifications),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildToggleTile(
                  icon: LucideIcons.trophy,
                  title: AppStrings.achievements,
                  subtitle: AppStrings.achievementsDesc,
                  value: _achievements,
                  onChanged: (v) => setState(() => _achievements = v),
                  color: AppColors.orange500,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildToggleTile(
                  icon: LucideIcons.barChart2,
                  title: AppStrings.weeklyReport,
                  subtitle: AppStrings.weeklyReportDesc,
                  value: _weeklyReport,
                  onChanged: (v) => setState(() => _weeklyReport = v),
                  color: AppColors.tertiary,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Delivery channels
                const AppSectionTitle(title: AppStrings.deliveryChannels),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildToggleTile(
                  icon: LucideIcons.bell,
                  title: AppStrings.pushNotificationsLabel,
                  subtitle: AppStrings.pushNotificationsDesc,
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildToggleTile(
                  icon: LucideIcons.mail,
                  title: AppStrings.emailNotificationsLabel,
                  subtitle: AppStrings.emailNotificationsDesc,
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                  color: AppColors.slate500,
                ),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
      ),
      title: Text(
        AppStrings.notifications,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface),
      ),
      centerTitle: true,
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: const SignatureGlowDecoration(),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.bellRing,
              size: AppDimensions.iconLG,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.notificationsEnabled,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  AppStrings.notificationsEnabledDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(
                      alpha: AppDimensions.opacityHigh,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return AppCard(
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
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSM),
          _buildCustomSwitch(value, onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
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
      ),
    );
  }
}
