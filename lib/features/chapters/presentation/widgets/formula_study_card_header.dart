import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class FormulaStudyCardHeader extends StatelessWidget {
  const FormulaStudyCardHeader({
    super.key,
    required this.formula,
    required this.index,
    required this.onMenuAction,
  });

  final Formula formula;
  final int index;
  final ValueChanged<String> onMenuAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingXL,
        AppDimensions.paddingLG,
        AppDimensions.paddingSM,
        0,
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: AppDimensions.fontSizeSM,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          Expanded(
            child: Text(
              formula.title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _OverflowMenu(onMenuAction: onMenuAction),
        ],
      ),
    );
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({required this.onMenuAction});

  final ValueChanged<String> onMenuAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuButton<String>(
      icon: Icon(
        LucideIcons.moreVertical,
        size: AppDimensions.iconMD,
        color: colorScheme.outline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      onSelected: onMenuAction,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'note',
          child: Row(
            children: [
              Icon(LucideIcons.stickyNote, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Add / Edit Note'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'compare',
          child: Row(
            children: [
              Icon(LucideIcons.gitCompare, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Compare Formula'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(LucideIcons.copy, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Copy LaTeX'),
            ],
          ),
        ),
      ],
    );
  }
}
