import 'dart:math';
import '../../domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../auth/auth.dart';

import '../cubit/study_planner_cubit.dart';
import '../cubit/study_planner_state.dart';

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({super.key});

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _sessionCountCtrl = TextEditingController(text: '3');
  final _durationCtrl = TextEditingController(text: '30');

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _sessionCountCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  Future<void> _createPlan() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) return;

    final userId = context.read<AuthCubit>().state.user?.uid;
    if (userId == null) return;

    final sessionCount = int.tryParse(_sessionCountCtrl.text) ?? 3;
    final duration = int.tryParse(_durationCtrl.text) ?? 30;
    final now = DateTime.now();
    final sessions = List.generate(sessionCount, (i) {
      final day = now.add(Duration(days: i));
      return ScheduledSession(
        id: 's_${now.millisecondsSinceEpoch}_${Random().nextInt(9999)}_$i',
        subjectId: 'general',
        chapterId: null,
        scheduledDate: DateTime(day.year, day.month, day.day, 18, 0),
        durationMinutes: duration,
      );
    });

    final plan = StudyPlan(
      id: 'plan_${now.millisecondsSinceEpoch}_${Random().nextInt(9999)}',
      title: title,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      sessions: sessions,
      createdAt: now,
      updatedAt: now,
    );

    await context.read<StudyPlannerCubit>().createPlan(
      userId: userId,
      plan: plan,
    );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Study Plan'), centerTitle: true),
      body: BlocListener<StudyPlannerCubit, StudyPlannerState>(
        listenWhen: (prev, curr) => curr.status == StudyPlannerStatus.error,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.localizedError(
                  fallback: state.errorMessage ?? 'Failed to create plan',
                ),
              ),
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: context.l10n.planTitle,
                  hintText: context.l10n.planTitleHint,
                  prefixIcon: const Icon(LucideIcons.calendar),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              TextField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'e.g. Cover chapters 1-3',
                  prefixIcon: Icon(LucideIcons.fileText),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              TextField(
                controller: _sessionCountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Number of Sessions',
                  prefixIcon: Icon(LucideIcons.list),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              TextField(
                controller: _durationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Duration per Session (min)',
                  prefixIcon: Icon(LucideIcons.clock),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              BlocBuilder<StudyPlannerCubit, StudyPlannerState>(
                buildWhen: (prev, curr) =>
                    curr.status == StudyPlannerStatus.creating,
                builder: (context, state) {
                  final isCreating =
                      state.status == StudyPlannerStatus.creating;
                  return FilledButton.icon(
                    onPressed: isCreating ? null : _createPlan,
                    icon: isCreating
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(LucideIcons.plus),
                    label: Text(
                      isCreating
                          ? context.l10n.creating
                          : context.l10n.createPlan,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
