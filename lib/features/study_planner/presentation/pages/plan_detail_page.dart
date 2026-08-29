import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../domain/domain.dart';
import '../cubit/study_planner_cubit.dart';
import '../cubit/study_planner_state.dart';
import '../widgets/session_tile.dart';

class PlanDetailPage extends StatelessWidget {
  const PlanDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final planId = GoRouterState.of(context).pathParameters['planId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studyPlannerDetailTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil),
            onPressed: () => context.pushNamed(
              AppRoutes.editPlanName,
              pathParameters: {'planId': planId},
            ),
            tooltip: context.l10n.editPlan,
          ),
          IconButton(
            icon: Icon(LucideIcons.trash2, color: colorScheme.error),
            onPressed: () => _confirmDelete(context, planId),
            tooltip: context.l10n.deletePlan,
          ),
        ],
      ),
      body: BlocBuilder<StudyPlannerCubit, StudyPlannerState>(
        buildWhen: (p, n) =>
            p.status != n.status ||
            p.plans != n.plans ||
            p.selectedPlan != n.selectedPlan,
        builder: (context, state) {
          if (state.status == StudyPlannerStatus.initial ||
              state.status == StudyPlannerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final plan = state.plans.firstWhere(
            (p) => p.id == planId,
            orElse: () => _findSelectedPlan(state),
          );

          if (plan.id.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    size: 48,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.studyPlannerNotFound),
                ],
              ),
            );
          }

          return _buildContent(context, plan, colorScheme);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String planId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deletePlan),
        content: const Text('Are you sure you want to delete this study plan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(context.l10n.cancelLabel),
          ),
          TextButton(
            onPressed: () {
              final userId = context.read<AuthCubit>().state.user?.uid;
              if (userId != null) {
                context.read<StudyPlannerCubit>().deletePlan(
                  userId: userId,
                  planId: planId,
                );
              }
              Navigator.of(ctx).pop();
              context.pop();
            },
            child: Text(
              context.l10n.deleteLabel,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  StudyPlan _findSelectedPlan(StudyPlannerState state) {
    final selected = state.selectedPlan;
    if (selected != null) return selected;
    return StudyPlan(
      id: '',
      title: '',
      sessions: const [],
      createdAt: DateTime(2000),
      updatedAt: DateTime(2000),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudyPlan plan,
    ColorScheme colorScheme,
  ) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      children: [
        _buildHeader(context, plan, colorScheme),
        const SizedBox(height: AppDimensions.paddingLG),
        _buildProgressSection(context, plan, colorScheme),
        const SizedBox(height: AppDimensions.paddingLG),
        Text(context.l10n.studyPlannerSessionsTitle, style: AppTextStyles.titleMedium),
        const SizedBox(height: AppDimensions.paddingSM),
        if (plan.sessions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                context.l10n.studyPlannerNoSessions,
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...plan.sessions.map((session) {
            return SessionTile(
              session: session,
              onToggle: () => _toggleSession(context, plan, session),
            );
          }),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHeader(
    BuildContext context,
    StudyPlan plan,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plan.title, style: AppTextStyles.headlineMedium),
        if (plan.description != null) ...[
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            plan.description!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          context.l10n.studyPlannerCreatedFormat(_formatDate(plan.createdAt)),
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, StudyPlan plan, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(context.l10n.studyPlannerProgress, style: AppTextStyles.labelLarge),
            Text(
              '${plan.completedSessions}/${plan.totalSessions}',
              style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          child: LinearProgressIndicator(
            value: plan.progressPercent,
            minHeight: 10,
            backgroundColor: colorScheme.surfaceContainerHighest,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleSession(
    BuildContext context,
    StudyPlan plan,
    ScheduledSession session,
  ) async {
    final userId = context.read<AuthCubit>().state.user?.uid;
    if (userId == null) return;

    final nextStatus = session.status == SessionStatus.completed
        ? SessionStatus.scheduled
        : SessionStatus.completed;

    await context.read<StudyPlannerCubit>().updateSessionStatus(
      userId: userId,
      planId: plan.id,
      sessionId: session.id,
      status: nextStatus,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextStatus == SessionStatus.completed
              ? context.l10n.studyPlannerSessionComplete
              : 'Session marked as scheduled',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
