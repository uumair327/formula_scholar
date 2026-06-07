library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';

import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class SavedChapterCard extends StatelessWidget {
  const SavedChapterCard({required this.chapter, super.key});

  final BookmarkedChapter chapter;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(chapter.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.paddingXXL),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
        child: Icon(
          LucideIcons.trash2,
          color: colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) {
        final cubit = context.read<SavedCubit>();
        cubit.removeSavedChapter(
          subjectId: chapter.subjectId,
          chapterId: chapter.chapterId,
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.chapterRemovedFromVault),
              action: SnackBarAction(
                label: context.l10n.undoLabel,
                onPressed: () => cubit.undoRemoveChapter(),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
      },
      child: AppCard(
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
                        '${context.l10n.vaultedOn} ${_formatDate(chapter.savedAt)}',
                        style: AppTextStyles.overline.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.drag_handle,
                  size: AppDimensions.iconSM,
                  color: colorScheme.outlineVariant,
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
