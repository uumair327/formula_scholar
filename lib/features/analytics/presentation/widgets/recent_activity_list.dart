import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';

import '../../domain/entities/recent_activity_item.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key, required this.items});

  final List<RecentActivityItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.history, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Recent Activity',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingLG,
                ),
                child: Center(
                  child: Text(
                    'No recent activity',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      AppIconCircle(
                        icon: item.isPositive
                            ? LucideIcons.checkCircle
                            : LucideIcons.trendingUp,
                        iconColor: item.isPositive
                            ? colorScheme.secondary
                            : colorScheme.primary,
                        backgroundColor:
                            (item.isPositive
                                    ? colorScheme.secondary
                                    : colorScheme.primary)
                                .withValues(alpha: AppDimensions.opacityFaint),
                      ),
                      const SizedBox(width: AppDimensions.paddingSM),
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
