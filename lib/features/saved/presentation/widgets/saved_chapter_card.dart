library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';

import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class SavedChapterCard extends StatelessWidget {
  const SavedChapterCard({required this.chapter, super.key});

  final BookmarkedChapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;


    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      onTap: () {
        context.goNamed(
          AppRoutes.formulaDetailName,
          pathParameters: {
            'subjectId': chapter.subjectId,
            'chapterId': chapter.chapterId,
          },
          queryParameters: {'name': chapter.chapterName},
        );
      },
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.subjectName,
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'SAVED ${_formatDate(chapter.savedAt)}',
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<SavedCubit>().removeSavedChapter(
                    subjectId: chapter.subjectId,
                    chapterId: chapter.chapterId,
                  );
                },
                icon: Icon(
                  Icons.bookmark,
                  size: AppDimensions.iconMD,
                  color: colorScheme.primary,
                ),
                tooltip: context.l10n.removeSavedChapter,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            chapter.chapterName,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          if (chapter.chapterSubtitle.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              chapter.chapterSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
