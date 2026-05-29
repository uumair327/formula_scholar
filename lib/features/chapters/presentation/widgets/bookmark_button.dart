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
      child: AppCard(
        onTap: () {
          HapticsHelper.lightImpact();
          onToggle();
        },
        color: isBookmarked
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHigh,
        borderRadius: AppDimensions.radiusXL,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLG,
          vertical: AppDimensions.paddingMD,
        ),
        boxShadow: const [],
        child: Icon(
          isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
          size: AppDimensions.iconMD,
          color: isBookmarked
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

