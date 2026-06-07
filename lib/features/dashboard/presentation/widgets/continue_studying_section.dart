library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class ContinueStudyingSection extends StatelessWidget {
  const ContinueStudyingSection({
    super.key,
    required this.recentStudies,
    required this.subjects,
    required this.onSubjectTap,
  });

  final List<RecentStudy> recentStudies;
  final List<Subject> subjects;
  final void Function(Subject subject) onSubjectTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (recentStudies.isEmpty) {
      return BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return AppCard(
            padding: const EdgeInsets.all(AppDimensions.paddingXXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.continueStudyingLabel,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                Text(
                  context.l10n.noRecentTitle,
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  context.l10n.noRecentDescription,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                ElevatedButton(
                  onPressed: () =>
                      StatefulNavigationShell.of(context).goBranch(1),
                  child: Text(context.l10n.openChaptersLabel),
                ),
              ],
            ),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            return Text(
              context.l10n.continueStudyingLabel,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: recentStudies.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppDimensions.paddingLG),
            itemBuilder: (context, index) {
              final study = recentStudies[index];
              final iconData = AppIconMapper.resolve(study.iconName);
              final accentColor = Color(study.colorValue);
              final bgColor = Color(study.backgroundColorValue);

              return EntranceWrapper(
                delay: Duration(milliseconds: index * 60),
                child: SizedBox(
                  width: 300,
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () => _onRecentStudyTap(context, study),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLG,
                      ),
                      child: AppCard(
                        padding: const EdgeInsets.all(AppDimensions.paddingLG),
                        child: Row(
                          children: [
                            AppIconCircle(
                              icon: iconData,
                              size: AppDimensions.avatarLG,
                              backgroundColor: bgColor,
                              iconColor: accentColor,
                              iconSize: AppDimensions.iconLG,
                            ),
                            const SizedBox(width: AppDimensions.paddingLG),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    study.title,
                                    style: AppTextStyles.labelLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(
                                    height: AppDimensions.paddingXXS,
                                  ),
                                  Text(
                                    '${study.subject} • ${study.lastViewed}',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Directionality.of(context) == TextDirection.rtl
                                  ? LucideIcons.chevronLeft
                                  : LucideIcons.chevronRight,
                              size: AppDimensions.iconMD,
                              color: colorScheme.outline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onRecentStudyTap(BuildContext context, RecentStudy study) {
    if (study.id == 'practice') {
      StatefulNavigationShell.of(context).goBranch(2);
      return;
    }

    if (study.subjectId.isNotEmpty) {
      final chapterId = study.id.replaceFirst('${study.subjectId}_', '');

      if (chapterId.isNotEmpty && chapterId != study.id) {
        context.goNamed(
          AppRoutes.formulaDetailName,
          pathParameters: {'subjectId': study.subjectId, 'chapterId': chapterId},
          queryParameters: {'name': study.title},
        );
        return;
      }

      final byId = subjects.where((s) => s.id == study.subjectId).toList();
      if (byId.isNotEmpty) {
        onSubjectTap(byId.first);
        return;
      }
    }

    final byName = subjects
        .where((s) => s.name.toLowerCase() == study.subject.toLowerCase())
        .toList();
    if (byName.isNotEmpty) {
      onSubjectTap(byName.first);
      return;
    }

    StatefulNavigationShell.of(context).goBranch(1);
  }
}
