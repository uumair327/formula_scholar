library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import 'curriculum_chip.dart';

class CurriculumChipRow<T> extends StatelessWidget {
  const CurriculumChipRow({
    super.key,
    required this.label,
    required this.items,
    required this.selectedId,
    required this.itemId,
    required this.itemLabel,
    this.itemSubtitle,
    required this.emptyMessage,
    required this.isBusy,
    required this.onSelected,
  });

  final String label;
  final List<T> items;
  final String? selectedId;
  final String Function(T item) itemId;
  final String Function(T item) itemLabel;
  final String Function(T item)? itemSubtitle;
  final String emptyMessage;
  final bool isBusy;
  final Future<void> Function(T item) onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingSM),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMD),
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  size: AppDimensions.iconSM,
                  color: colorScheme.onSurfaceVariant.withValues(
                    alpha: AppDimensions.opacityMedium,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  emptyMessage,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: AppDimensions.chipContainerHeight,
            child: ListView.separated(
              addAutomaticKeepAlives: false,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppDimensions.paddingSM),
              itemBuilder: (context, index) {
                final item = items[index];
                final selected = itemId(item) == selectedId;
                return CurriculumChip(
                  label: itemLabel(item),
                  subtitle: itemSubtitle?.call(item),
                  selected: selected,
                  onTap: isBusy ? null : () => unawaited(onSelected(item)),
                );
              },
            ),
          ),
      ],
    );
  }
}
