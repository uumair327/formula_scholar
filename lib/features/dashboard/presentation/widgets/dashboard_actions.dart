library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../chapters/chapters.dart';
import '../../domain/domain.dart';
import '../cubit/dashboard_state.dart';

void resumeLearning(BuildContext context, DashboardState state) {
  final featured = state.subjects.where((s) => s.isFeatured).toList();
  if (featured.isNotEmpty) {
    onSubjectTap(context, featured.first);
    return;
  }
  if (state.subjects.isNotEmpty) {
    onSubjectTap(context, state.subjects.first);
    return;
  }
  context.read<SubjectSelectionCubit>().clearSelection();
  StatefulNavigationShell.of(context).goBranch(1);
}

void onSubjectTap(BuildContext context, Subject subject) {
  context.read<SubjectSelectionCubit>().selectSubject(
    id: subject.id,
    name: subject.name,
    category: subject.category,
    description: subject.description,
    iconName: subject.iconName,
    subtitle: subject.subtitle ?? '',
  );
  context.goNamed(
    AppRoutes.subjectChaptersName,
    pathParameters: {'subjectId': subject.id},
  );
}

void showSubjectAnalytics(
  BuildContext context,
  DashboardState state,
  Subject subject,
) {
  final mastery = subject.masteryPercentage ?? 0;
  final progressPercent = mastery.round().clamp(0, 100);
  final completedFormulas = subject.formulaCount == 0
      ? 0
      : ((subject.formulaCount * progressPercent) / 100).round().clamp(
          0,
          subject.formulaCount,
        );

  final grade = state.selectedGradeName.isNotEmpty
      ? 'Grade ${state.selectedGradeName}'
      : AppStrings.dashboardCurriculumPending;

  SubjectAnalyticsSheet.show(
    context,
    subjectName: subject.name,
    progressPercent: progressPercent,
    completedFormulas: completedFormulas,
    totalFormulas: subject.formulaCount,
    grade: grade,
  );
}
