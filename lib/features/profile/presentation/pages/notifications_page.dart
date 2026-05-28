import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_status_card.dart';
import '../widgets/notification_toggle_tile.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listenWhen: (p, n) =>
          n.status == NotificationsStatus.error &&
          n.errorMessage != null &&
          n.errorMessage!.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.localizedError(
                errorKey: state.errorKey,
                fallback: state.errorMessage,
              ),
            ),
          ),
        );
      },
      buildWhen: (p, n) =>
          p.preferences != n.preferences || p.status != n.status,
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
                onRefresh: () =>
                    context.read<NotificationsCubit>().loadPreferences(),
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(context),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Responsive.value(
                          context: context,
                          mobile: AppDimensions.paddingXL,
                          desktop:
                              AppDimensions.paddingSectionLG * 2 +
                              AppDimensions.paddingXL,
                        ),
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: AppDimensions.paddingXXL),
                          EntranceWrapper.stagger(
                            index: 0,
                            child: const NotificationStatusCard(),
                          ),
                          const SizedBox(height: AppDimensions.paddingXXL),
                          EntranceWrapper.stagger(
                            index: 1,
                            child: AppSectionTitle(
                              title: context.l10n.studyNotifications,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingLG),
                          EntranceWrapper.stagger(
                            index: 2,
                            child: NotificationToggleTile(
                              icon: LucideIcons.clock,
                              title: context.l10n.studyReminders,
                              subtitle: context.l10n.studyRemindersDesc,
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
                            child: NotificationToggleTile(
                              icon: LucideIcons.flame,
                              title: context.l10n.streakAlerts,
                              subtitle: context.l10n.streakAlertsDesc,
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
                            child: NotificationToggleTile(
                              icon: LucideIcons.sparkles,
                              title: context.l10n.newContent,
                              subtitle: context.l10n.newContentDesc,
                              value: prefs.newContent,
                              onChanged: (v) => context
                                  .read<NotificationsCubit>()
                                  .updatePreferences(
                                    prefs.copyWith(newContent: v),
                                  ),
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingXXL),
                          EntranceWrapper.stagger(
                            index: 5,
                            child: AppSectionTitle(
                              title: context.l10n.achievementNotifications,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingLG),
                          EntranceWrapper.stagger(
                            index: 6,
                            child: NotificationToggleTile(
                              icon: LucideIcons.trophy,
                              title: context.l10n.achievements,
                              subtitle: context.l10n.achievementsDesc,
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
                            child: NotificationToggleTile(
                              icon: LucideIcons.barChart2,
                              title: context.l10n.weeklyReport,
                              subtitle: context.l10n.weeklyReportDesc,
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
                            child: AppSectionTitle(
                              title: context.l10n.deliveryChannels,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.paddingLG),
                          EntranceWrapper.stagger(
                            index: 9,
                            child: NotificationToggleTile(
                              icon: LucideIcons.bell,
                              title: context.l10n.pushNotificationsLabel,
                              subtitle: context.l10n.pushNotificationsDesc,
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
                            child: NotificationToggleTile(
                              icon: LucideIcons.mail,
                              title: context.l10n.emailNotificationsLabel,
                              subtitle: context.l10n.emailNotificationsDesc,
                              value: prefs.emailNotifications,
                              onChanged: (v) => context
                                  .read<NotificationsCubit>()
                                  .updatePreferences(
                                    prefs.copyWith(emailNotifications: v),
                                  ),
                              color: colorScheme.outline,
                            ),
                          ),
                          const SizedBox(
                            height: AppDimensions.bottomNavPadding,
                          ),
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
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
      titleWidget: Text(
        context.l10n.notifications,
        style: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
