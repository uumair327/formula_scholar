import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../cubit/study_planner_cubit.dart';
import '../cubit/study_planner_state.dart';

class EditPlanPage extends StatefulWidget {
  const EditPlanPage({super.key});

  @override
  State<EditPlanPage> createState() => _EditPlanPageState();
}

class _EditPlanPageState extends State<EditPlanPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  StudyPlan? _plan;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_plan == null) {
      final planId = GoRouterState.of(context).pathParameters['planId'] ?? '';
      final state = context.read<StudyPlannerCubit>().state;
      _plan = state.plans.firstWhere(
        (p) => p.id == planId,
        orElse: () => state.selectedPlan ?? _plan!,
      );
      if (_plan != null) {
        _titleCtrl.text = _plan!.title;
        _descCtrl.text = _plan!.description ?? '';
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePlan() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty || _plan == null) return;

    final userId = context.read<AuthCubit>().state.user?.uid;
    if (userId == null) return;

    final updatedPlan = _plan!.copyWith(
      title: title,
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      updatedAt: DateTime.now(),
    );

    await context.read<StudyPlannerCubit>().updatePlan(
      userId: userId,
      plan: updatedPlan,
    );

    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Plan'), centerTitle: true),
      body: BlocListener<StudyPlannerCubit, StudyPlannerState>(
        listenWhen: (prev, curr) => curr.status == StudyPlannerStatus.error,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                context.localizedError(
                  fallback: state.errorMessage ?? 'Failed to update plan',
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
                decoration: const InputDecoration(
                  labelText: 'Plan Title',
                  hintText: 'e.g. Week 1 Revision',
                  prefixIcon: Icon(LucideIcons.calendar),
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
              const SizedBox(height: AppDimensions.paddingXXL),
              FilledButton.icon(
                onPressed: _savePlan,
                icon: const Icon(LucideIcons.save),
                label: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
