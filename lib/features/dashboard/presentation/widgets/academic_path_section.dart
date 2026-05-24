library;

import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import 'quiz_card.dart';
import 'subject_card.dart';

class AcademicPathSection extends StatelessWidget {
  const AcademicPathSection({
    super.key,
    required this.subjects,
    required this.onSubjectTap,
    required this.onShowAnalytics,
    this.onViewAll,
  });

  final List<Subject> subjects;
  final void Function(Subject subject) onSubjectTap;
  final void Function(Subject subject) onShowAnalytics;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final featured = subjects.where((s) => s.isFeatured).toList();
    final others = subjects.where((s) => !s.isFeatured).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.dashboardAcademicPath,
          actionLabel: AppStrings.viewAll,
          onAction: onViewAll,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        AnimatedSwitcher(
          duration: AppDurations.animationDefault,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: LayoutBuilder(
            key: ValueKey('subjects_${subjects.length}_${subjects.hashCode}'),
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > AppDimensions.breakpointWide;
              if (isWide) {
                return Column(
                  children: [
                    if (featured.isNotEmpty || others.isNotEmpty)
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (featured.isNotEmpty)
                              Expanded(
                                flex: 2,
                                child: SubjectCard(
                                  subject: featured.first,
                                  onTap: () => onSubjectTap(featured.first),
                                  onLongPress: () => onShowAnalytics(featured.first),
                                ),
                              ),
                            if (featured.isNotEmpty && others.isNotEmpty)
                              const SizedBox(width: AppDimensions.paddingLG),
                            if (others.isNotEmpty)
                              Expanded(
                                child: SubjectCard(
                                  subject: others.first,
                                  onTap: () => onSubjectTap(others.first),
                                  onLongPress: () => onShowAnalytics(others.first),
                                ),
                              ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppDimensions.paddingLG),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: AppDimensions.paddingLG,
                        runSpacing: AppDimensions.paddingLG,
                        alignment: WrapAlignment.start,
                        children: [
                          ...others.skip(1).map((subject) {
                            final itemWidth = (constraints.maxWidth - AppDimensions.paddingLG) / 2.05;
                            return SizedBox(
                              width: itemWidth,
                              child: SubjectCard(
                                subject: subject,
                                onTap: () => onSubjectTap(subject),
                                onLongPress: () => onShowAnalytics(subject),
                              ),
                            );
                          }),
                          SizedBox(
                            width: (constraints.maxWidth - AppDimensions.paddingLG) / 2.05,
                            child: const QuizCard(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  ...subjects.map(
                    (subject) => Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
                      child: SubjectCard(
                        subject: subject,
                        onTap: () => onSubjectTap(subject),
                        onLongPress: () => onShowAnalytics(subject),
                      ),
                    ),
                  ),
                  const QuizCard(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
