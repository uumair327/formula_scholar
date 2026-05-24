import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../domain/domain.dart';
import '../chapter_cards.dart';

class ChapterCardsList extends StatelessWidget {
  const ChapterCardsList({super.key, required this.chapters, required this.subjectId});

  final List<Chapter> chapters;
  final String subjectId;

  @override
  Widget build(BuildContext context) {
    final featured = chapters
        .where((c) => c.isInProgress)
        .fold<Chapter?>(null, (best, c) => best == null || c.progressPercent > best.progressPercent ? c : best);

    final remaining = featured == null ? chapters : chapters.where((c) => c.id != featured.id).toList();

    return Column(
      children: [
        if (featured != null) ...[
          FeaturedChapterCard(chapter: featured, subjectId: subjectId),
          const SizedBox(height: AppDimensions.paddingLG),
        ],
        ...remaining.map((chapter) {
          final effectivelyLocked = chapter.isLocked && !AppFeatureFlags.unlockAllChapters;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.paddingLG),
            child: effectivelyLocked
                ? LockedChapterCard(chapter: chapter)
                : CompactChapterCard(chapter: chapter, subjectId: subjectId),
          );
        }),
      ],
    );
  }
}
