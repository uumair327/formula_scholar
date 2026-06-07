library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';

import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class SavedNoteCard extends StatelessWidget {
  const SavedNoteCard({required this.note, super.key});

  final SavedNote note;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(note.id),
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
        cubit.removeNote(note.id);

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(context.l10n.noteRemovedFromVault),
              action: SnackBarAction(
                label: context.l10n.undoLabel,
                onPressed: () => cubit.undoRemoveNote(),
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
              children: [
                AppIconCircle(
                  icon: LucideIcons.stickyNote,
                  backgroundColor: colorScheme.secondaryContainer.withValues(
                    alpha: AppDimensions.opacityFaint,
                  ),
                  iconColor: colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.paddingLG),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.subject,
                        style: AppTextStyles.overline.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${context.l10n.vaultedOn} ${_formatDate(note.savedAt)}',
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
            const SizedBox(height: AppDimensions.paddingMD),
            Text(
              note.title,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              note.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppDimensions.lineHeightDefault,
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
