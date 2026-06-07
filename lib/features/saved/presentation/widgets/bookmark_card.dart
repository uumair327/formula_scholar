library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({required this.bookmark, super.key});

  final BookmarkedFormula bookmark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(bookmark.id),
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
        cubit.removeBookmark(bookmark.id);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.formulaRemovedFromVault),
              action: SnackBarAction(
                label: context.l10n.undoLabel,
                onPressed: () => cubit.undoRemoveBookmark(),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
      },
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookmark.subject,
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${context.l10n.vaultedOn} ${_formatDate(bookmark.savedAt)}',
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                // Replaced IconButton with a drag handle hint
                Icon(
                  Icons.drag_handle,
                  size: AppDimensions.iconSM,
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              bookmark.title,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                border: Border.all(color: colorScheme.surfaceContainerHigh),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Math.tex(
                    bookmark.formula,
                    textStyle: AppTextStyles.headlineSmall.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
