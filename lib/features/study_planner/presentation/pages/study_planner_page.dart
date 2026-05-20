import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../domain/domain.dart';
import '../cubit/study_planner_cubit.dart';
import '../cubit/study_planner_state.dart';
import '../widgets/plan_card.dart';

class StudyPlannerPage extends StatefulWidget {
  const StudyPlannerPage({super.key});

  @override
  State<StudyPlannerPage> createState() => _StudyPlannerPageState();
}

class _StudyPlannerPageState extends State<StudyPlannerPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRoutes.createPlanName),
        icon: const Icon(LucideIcons.plus),
        label: const Text('New Plan'),
      ),
      body: BlocBuilder<StudyPlannerCubit, StudyPlannerState>(
        builder: (context, state) {
          if (state.status == StudyPlannerStatus.initial ||
              state.status == StudyPlannerStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == StudyPlannerStatus.error &&
              state.plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.alertCircle,
                      size: 48, color: colorScheme.error),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'Failed to load plans'),
                ],
              ),
            );
          }

          if (state.plans.isEmpty) {
            return ListView(
              children: [
                const SizedBox(height: 80),
                Icon(
                  LucideIcons.calendar,
                  size: 64,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No study plans yet',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first study plan to get started',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                  ),
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.pushNamed(AppRoutes.createPlanName),
                    icon: const Icon(LucideIcons.plus),
                    label: const Text('Create Plan'),
                  ),
                ),
              ],
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final userId = context.read<AuthCubit>().state.user?.uid;
              if (userId != null) {
                context.read<StudyPlannerCubit>().loadPlans(userId);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: AppDimensions.paddingMD,
                bottom: 80,
              ),
              itemCount: state.plans.length,
              itemBuilder: (context, index) {
                final plan = state.plans[index];
                return PlanCard(
                  plan: plan,
                  onTap: () => context.pushNamed(
                    AppRoutes.planDetailName,
                    pathParameters: {'planId': plan.id},
                  ),
                  onDelete: () => _confirmDelete(context, plan),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, StudyPlan plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text('Delete "${plan.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final userId = context.read<AuthCubit>().state.user?.uid;
              if (userId != null) {
                context
                    .read<StudyPlannerCubit>()
                    .deletePlan(userId: userId, planId: plan.id);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
