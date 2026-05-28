import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class SessionTile extends StatelessWidget {
  const SessionTile({super.key, required this.session, this.onComplete});

  final ScheduledSession session;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = session.status == SessionStatus.completed;
    final isMissed = session.status == SessionStatus.missed;

    return ListTile(
      leading: Icon(
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
      title: Text(
        '${session.durationMinutes} min study',
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: Text(
        '${session.scheduledDate.day}/${session.scheduledDate.month}/${session.scheduledDate.year}',
        style: AppTextStyles.bodySmall.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: isCompleted
          ? Icon(LucideIcons.check, color: colorScheme.primary)
          : (onComplete != null
                ? TextButton(
                    onPressed: onComplete,
                    child: const Text('Complete'),
                  )
                : null),
    );
  }
}
