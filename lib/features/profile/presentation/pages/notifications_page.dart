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
          return const Scaffold(body: NotificationsShimmer());
        }

        final colorScheme = Theme.of(context).colorScheme;
        final prefs = state.preferences;
        final isBusy = state.status == NotificationsStatus.saving;

        return Scaffold(
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => context.read<NotificationsCubit>().loadPreferences(),
                child: CustomScrollView(
                  slivers: [
                  _buildAppBar(context),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.value(
                        context: context,
                        mobile: AppDimensions.paddingXL,
                        desktop: AppDimensions.paddingSectionLG * 2 + AppDimensions.paddingXL,
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(
                          index: 0,
                          child: _buildStatusCard(context),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(
                          index: 1,
                          child: const AppSectionTitle(
                            title: AppStrings.studyNotifications,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(
                          index: 2,
                          child: _buildToggleTile(
                            context: context,
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
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 3,
                          child: _buildToggleTile(
                            context: context,
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
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 4,
                          child: _buildToggleTile(
                            context: context,
                            icon: LucideIcons.sparkles,
                            title: AppStrings.newContent,
                            subtitle: AppStrings.newContentDesc,
                            value: prefs.newContent,
                            onChanged: (v) => context
                                .read<NotificationsCubit>()
                                .updatePreferences(prefs.copyWith(newContent: v)),
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(
                          index: 5,
                          child: const AppSectionTitle(
                            title: AppStrings.achievementNotifications,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(
                          index: 6,
                          child: _buildToggleTile(
                            context: context,
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
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 7,
                          child: _buildToggleTile(
                            context: context,
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
                        ),
                        const SizedBox(height: AppDimensions.paddingXXL),
                        EntranceWrapper.stagger(
                          index: 8,
                          child: const AppSectionTitle(
                            title: AppStrings.deliveryChannels,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        EntranceWrapper.stagger(
                          index: 9,
                          child: _buildToggleTile(
                            context: context,
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
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        EntranceWrapper.stagger(
                          index: 10,
                          child: _buildToggleTile(
                            context: context,
                            icon: LucideIcons.mail,
                            title: AppStrings.emailNotificationsLabel,
                            subtitle: AppStrings.emailNotificationsDesc,
                            value: prefs.emailNotifications,
                            onChanged: (v) => context
                                .read<NotificationsCubit>()
                                .updatePreferences(
                                  prefs.copyWith(emailNotifications: v),
                                ),
                            color: colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.bottomNavPadding),
                      ]),
                    ),
                  ),
                ],
              ),
              ),
              if (isBusy)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      color: Theme.of(context).colorScheme.surface.withValues(
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

  Widget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverGlassAppBar(
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.profilePath),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
      ),
      titleWidget: Text(
        AppStrings.notifications,
        style: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: signatureGlowDecoration(colorScheme),
      child: Row(
        children: [
          Container(
            width: AppDimensions.avatarLG,
            height: AppDimensions.avatarLG,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.bellRing,
              size: AppDimensions.iconLG,
              color: colorScheme.onPrimary,
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
                    color: colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXS),
                Text(
                  AppStrings.notificationsEnabledDesc,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onPrimary.withValues(
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

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
                    color: colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.paddingSM),
          _buildCustomSwitch(context, value, onChanged),
        ],
      ),
    );
  }

  Widget _buildCustomSwitch(
    BuildContext context,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: AppStrings.notifications,
      toggled: value,
      child: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colorScheme.primary,
        activeTrackColor: colorScheme.primaryContainer,
      ),
    );
  }
}
