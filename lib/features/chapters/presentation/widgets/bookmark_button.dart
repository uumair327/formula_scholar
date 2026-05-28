library;

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onToggle,
  });

  final bool isBookmarked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: isBookmarked
          ? context.l10n.removeBookmark
          : context.l10n.bookmarkChapter,
      child: Material(
        color: isBookmarked
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: InkWell(
          onTap: () {
            HapticsHelper.lightImpact();
            onToggle();
          },
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: AnimatedContainer(
            duration: AppDurations.animationFast,
            curve: AppDurations.curveDefault,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLG,
              vertical: AppDimensions.paddingMD,
            ),
            child: Icon(
              isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
              size: AppDimensions.iconMD,
              color: isBookmarked
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
