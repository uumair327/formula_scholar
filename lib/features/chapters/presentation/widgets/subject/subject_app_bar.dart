import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';
import '../../../../auth/auth.dart';
import '../../../../profile/domain/domain.dart';
import '../../cubit/chapters_cubit.dart';
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
            subject?.name ?? AppStrings.selectSubjectTitle,
            style: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface, fontWeight: FontWeight.w800),
          ),
          if (subject != null)
            Row(
              children: [
                Text(AppStrings.breadcrumbHome, style: AppTextStyles.overline.copyWith(
                  color: colorScheme.outline, fontSize: AppDimensions.fontSizeXS,
                )),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? LucideIcons.chevronLeft
                      : LucideIcons.chevronRight,
                  size: AppDimensions.iconXS,
                  color: colorScheme.outlineVariant,
                ),
                Text(subject!.name.toUpperCase(), style: AppTextStyles.overline.copyWith(
                  color: AppColors.primary, fontSize: AppDimensions.fontSizeXS,
                )),
              ],
            ),
        ],
      ),
      actions: [
        _AnalyticsButton(subject: subject),
        const SizedBox(width: AppDimensions.paddingMD),
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) => prev.user != curr.user,
          builder: (context, authState) {
            final photoUrl = authState.user?.photoUrl ?? AppAssets.dashboardStudentProfileUrl;
            return GestureDetector(
              onTap: () => context.push(AppRoutes.profilePath),
              child: AppAvatar(imageUrl: photoUrl, placeholderColor: colorScheme.surfaceContainerHighest),
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
    return IconButton(
      onPressed: () async {
        if (subject == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.selectSubjectFirst)),
          );
          return;
        }
        unawaited(showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        ));
        final statsResult = await getIt<GetProfileStatsUseCase>().call();
        var currentStreak = 0;
        if (statsResult is Success<List<ProfileStat>>) {
          final streakStat = statsResult.data.where((s) => s.id == 'streak').firstOrNull;
          currentStreak = int.tryParse(streakStat?.value ?? '0') ?? 0;
        }
        if (!context.mounted) return;
        Navigator.of(context).pop();
        final chapterState = context.read<ChaptersCubit>().state;
        var total = 0;
        var completed = 0;
        for (var chapter in chapterState.chapters) {
          total += chapter.totalFormulas;
          completed += chapter.completedFormulas;
        }
        final progress = total > 0 ? ((completed / total) * 100).toInt() : 0;
        SubjectAnalyticsSheet.show(
          context,
          subjectName: subject!.name,
          progressPercent: progress,
          completedFormulas: completed,
          totalFormulas: total,
          currentStreak: currentStreak,
          grade: context.read<CurriculumCubit>().state.gradeLabel ?? AppStrings.unknownGrade,
        );
      },
      icon: const AppIconCircle(
        icon: LucideIcons.barChart3,
        size: AppDimensions.avatarMD,
        backgroundColor: AppColors.primaryFixed,
        iconColor: AppColors.primary,
        iconSize: AppDimensions.iconMD,
        borderRadius: AppDimensions.radiusMD,
      ),
    );
  }
}
