import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, this.onTap, this.onDelete});

  final StudyPlan plan;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = plan.progressPercent;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingXS,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: AppDimensions.iconMD,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Expanded(
                    child: Text(
                      plan.title,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: Icon(
                        LucideIcons.trash2,
                        size: AppDimensions.iconSM,
                        color: colorScheme.error,
                      ),
                      onPressed: onDelete,
                      tooltip: context.l10n.deletePlan,
                    ),
                ],
              ),
              if (plan.description != null) ...[
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  plan.description!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: AppDimensions.paddingSM),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
              ),
              const SizedBox(height: AppDimensions.paddingXS),
              Text(
                '${plan.completedSessions}/${plan.totalSessions} sessions',
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
