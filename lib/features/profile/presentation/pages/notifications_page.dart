import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';

/// Notifications settings page – manage notification preferences.
///
/// Accessible from profile settings. Shows toggle options for
/// different notification categories with premium styling.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state.status == NotificationsStatus.error &&
            state.errorMessage != null &&
            state.errorMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        if (state.status == NotificationsStatus.loading ||
            state.status == NotificationsStatus.initial) {
          return const Scaffold(body: AppLoadingState());
        }

        final prefs = state.preferences;
        final isBusy = state.status == NotificationsStatus.saving;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildAppBar(context),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingXL,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppDimensions.paddingXXL),
                        _buildStatusCard(),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        const AppSectionTitle(
                          title: AppStrings.studyNotifications,
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        _buildToggleTile(
                          icon: LucideIcons.clock,
                          title: AppStrings.studyReminders,
                          subtitle: AppStrings.studyRemindersDesc,
                          value: prefs.studyReminders,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(studyReminders: v),
                              ),
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        _buildToggleTile(
                          icon: LucideIcons.flame,
                          title: AppStrings.streakAlerts,
                          subtitle: AppStrings.streakAlertsDesc,
                          value: prefs.streakAlerts,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(streakAlerts: v),
                              ),
                          color: AppColors.orange500,
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        _buildToggleTile(
                          icon: LucideIcons.sparkles,
                          title: AppStrings.newContent,
                          subtitle: AppStrings.newContentDesc,
                          value: prefs.newContent,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(prefs.copyWith(newContent: v)),
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        const AppSectionTitle(
                          title: AppStrings.achievementNotifications,
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        _buildToggleTile(
                          icon: LucideIcons.trophy,
                          title: AppStrings.achievements,
                          subtitle: AppStrings.achievementsDesc,
                          value: prefs.achievements,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(achievements: v),
                              ),
                          color: AppColors.orange500,
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        _buildToggleTile(
                          icon: LucideIcons.barChart2,
                          title: AppStrings.weeklyReport,
                          subtitle: AppStrings.weeklyReportDesc,
                          value: prefs.weeklyReport,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(weeklyReport: v),
                              ),
                          color: AppColors.tertiary,
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        const AppSectionTitle(
                          title: AppStrings.deliveryChannels,
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        _buildToggleTile(
                          icon: LucideIcons.bell,
                          title: AppStrings.pushNotificationsLabel,
                          subtitle: AppStrings.pushNotificationsDesc,
                          value: prefs.pushNotifications,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(pushNotifications: v),
                              ),
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        _buildToggleTile(
                          icon: LucideIcons.mail,
                          title: AppStrings.emailNotificationsLabel,
                          subtitle: AppStrings.emailNotificationsDesc,
                          value: prefs.emailNotifications,
                          onChanged: (v) => context
                              .read<NotificationsCubit>()
                              .updatePreferences(
                                prefs.copyWith(emailNotifications: v),
                              ),
                          color: AppColors.slate500,
                        ),
                        const SizedBox(height: AppDimensions.bottomNavPadding),
                      ]),
                    ),
                  ),
                ],
              ),
              if (isBusy)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: AppColors.surface.withValues(
                        alpha: AppDimensions.opacitySubtle,
                      ),
                      alignment: Alignment.topCenter,
                      child: const Padding(
                        padding: EdgeInsets.only(top: AppDimensions.paddingXXL),
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
        onPressed: () => context.go(AppRoutes.profilePath),
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
