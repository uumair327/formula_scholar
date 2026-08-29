import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({
    super.key,
    required this.session,
    this.onComplete,
    this.onToggle,
  });

  final ScheduledSession session;
  final VoidCallback? onComplete;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = session.status == SessionStatus.completed;
    final isMissed = session.status == SessionStatus.missed;
    final callback = onToggle ?? onComplete;

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: AppDimensions.paddingXS,
      ),
      elevation: 0,
      color: isCompleted
          ? colorScheme.primaryContainer.withValues(alpha: 0.25)
          : colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        side: BorderSide(
          color: isCompleted
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: ListTile(
        onTap: callback,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        leading: IconButton(
          icon: Icon(
            isCompleted
                ? LucideIcons.checkCircle2
                : isMissed
                ? LucideIcons.xCircle
                : LucideIcons.circle,
            color: isCompleted
                ? colorScheme.primary
                : isMissed
                ? colorScheme.error
                : colorScheme.outline,
          ),
          onPressed: callback,
          tooltip: isCompleted ? 'Mark incomplete' : 'Mark complete',
        ),
        title: Text(
          context.l10n.studyPlannerMinStudy(session.durationMinutes),
          style: AppTextStyles.bodyMedium.copyWith(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? colorScheme.onSurface.withValues(alpha: 0.6)
                : colorScheme.onSurface,
            fontWeight: isCompleted ? FontWeight.normal : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${session.scheduledDate.day}/${session.scheduledDate.month}/${session.scheduledDate.year}',
          style: AppTextStyles.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: isCompleted
            ? Icon(LucideIcons.check, color: colorScheme.primary)
            : (callback != null
                ? TextButton(
                    onPressed: callback,
                    child: Text(context.l10n.studyPlannerCompleteAction),
                  )
                : null),
      ),
    );
  }
}
