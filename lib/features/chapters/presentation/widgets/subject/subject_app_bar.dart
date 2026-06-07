import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../../../auth/auth.dart';
import '../../../../profile/domain/domain.dart';
import '../../cubit/chapters_cubit.dart';
import '../../cubit/subject_stats_cubit.dart';
import '../subject_analytics_sheet.dart';

class SubjectChaptersAppBar extends StatelessWidget {
  const SubjectChaptersAppBar({super.key, required this.subject});

  final SelectedSubject? subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverGlassAppBar(
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subject?.name ?? context.l10n.selectSubjectTitle,
            style: AppTextStyles.titleMedium.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      actions: [
        _AnalyticsButton(subject: subject),
        const SizedBox(width: AppDimensions.paddingMD),
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) => prev.user != curr.user,
          builder: (context, authState) {
            final photoUrl =
                authState.user?.photoUrl ??
                AppAssets.dashboardStudentProfileUrl;
            return Tooltip(
              message: context.l10n.viewProfile,
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.profilePath),
                child: AppAvatar(
                  imageUrl: photoUrl,
                  placeholderColor: colorScheme.surfaceContainerHighest,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: AppDimensions.paddingLG),
      ],
    );
  }
}

class _AnalyticsButton extends StatelessWidget {
  const _AnalyticsButton({required this.subject});

  final SelectedSubject? subject;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () async {
        if (subject == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.selectSubjectFirst)),
          );
          return;
        }
        unawaited(
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          ),
        );
        final cubit = SubjectStatsCubit(
          getIt<GetProfileStatsUseCase>(),
          context.read<ChaptersCubit>(),
          context.read<CurriculumCubit>(),
        );
        bool dialogPopped = false;
        try {
          final data = await cubit.loadSelected();
          if (!context.mounted) return;
          Navigator.of(context, rootNavigator: true).pop();
          dialogPopped = true;
          SubjectAnalyticsSheet.show(
            context,
            subjectName: subject!.name,
            progressPercent: data.progressPercent,
            completedFormulas: data.completedFormulas,
            totalFormulas: data.totalFormulas,
            currentStreak: data.currentStreak,
            grade: data.gradeLabel,
          );
        } catch (e) {
          if (!dialogPopped && context.mounted) {
            Navigator.of(context, rootNavigator: true).pop();
            dialogPopped = true;
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to load analytics')),
            );
          }
        } finally {
          await cubit.close();
        }
      },
      icon: AppIconCircle(
        icon: LucideIcons.barChart3,
        size: AppDimensions.avatarMD,
        backgroundColor: colorScheme.primaryContainer,
        iconColor: colorScheme.onPrimaryContainer,
        iconSize: AppDimensions.iconMD,
        borderRadius: AppDimensions.radiusMD,
      ),
      tooltip: subject == null
          ? context.l10n.selectSubjectFirst
          : context.l10n.viewAnalytics,
    );
  }
}
