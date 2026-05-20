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

class PlanDetailPage extends StatefulWidget {
  const PlanDetailPage({super.key});

  @override
  State<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthCubit>().state.user?.uid;
    if (userId != null) {
      context.read<StudyPlannerCubit>().loadPlans(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final planId = GoRouterState.of(context).pathParameters['planId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil),
            onPressed: () => context.pushNamed(
              AppRoutes.editPlanName,
              pathParameters: {'planId': planId},
            ),
          ),
        ],
      ),
      body: BlocBuilder<StudyPlannerCubit, StudyPlannerState>(
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
                  Icon(LucideIcons.alertCircle,
                      size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  const Text('Plan not found'),
                ],
              ),
            );
          }

          return _buildContent(context, plan, colorScheme);
        },
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
        _buildProgressSection(plan, colorScheme),
        const SizedBox(height: AppDimensions.paddingLG),
        Text(
          'Sessions',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        if (plan.sessions.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No sessions in this plan',
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
              onComplete: session.status == SessionStatus.scheduled
                  ? () => _completeSession(context, plan, session)
                  : null,
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
          'Created ${_formatDate(plan.createdAt)}',
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(StudyPlan plan, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTextStyles.labelLarge,
            ),
            Text(
              '${plan.completedSessions}/${plan.totalSessions}',
              style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        LinearProgressIndicator(
          value: plan.progressPercent,
          minHeight: 8,
          backgroundColor: colorScheme.surfaceContainerHighest,
        ),
      ],
    );
  }

  Future<void> _completeSession(
    BuildContext context,
    StudyPlan plan,
    ScheduledSession session,
  ) async {
    final userId = context.read<AuthCubit>().state.user?.uid;
    if (userId == null) return;

    await context.read<StudyPlannerCubit>().markSessionComplete(
          userId: userId,
          planId: plan.id,
          sessionId: session.id,
        );

    if (!mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session marked as complete')),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
