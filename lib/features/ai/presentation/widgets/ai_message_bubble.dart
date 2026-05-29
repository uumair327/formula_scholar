import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class AiMessageBubble extends StatelessWidget {
  const AiMessageBubble({
    super.key,
    required this.message,
    required this.onSpeak,
  });

  final AiMessage message;
  final ValueChanged<String> onSpeak;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUser = message.role == AiMessageRole.user;
    final backgroundColor = isUser
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;
    final foregroundColor = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppDimensions.radiusLG),
              topRight: const Radius.circular(AppDimensions.radiusLG),
              bottomLeft: Radius.circular(
                isUser ? AppDimensions.radiusLG : AppDimensions.radiusSM,
              ),
              bottomRight: Radius.circular(
                isUser ? AppDimensions.radiusSM : AppDimensions.radiusLG,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content.isEmpty ? 'Thinking...' : message.content,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: foregroundColor,
                  height: 1.45,
                ),
              ),
              if (!isUser && message.content.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingSM),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      tooltip: 'Read aloud',
                      onPressed: () => onSpeak(message.content),
                      icon: Icon(
                        LucideIcons.playCircle,
                        size: AppDimensions.iconMD,
                        color: colorScheme.primary,
                      ),
                    ),
                    if (message.actionRequest != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: AppDimensions.paddingSM,
                        ),
                        child: Chip(
                          visualDensity: VisualDensity.compact,
                          avatar: const Icon(
                            LucideIcons.checkCircle2,
                            size: AppDimensions.iconSM,
                          ),
                          label: Text(message.actionRequest!.action),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
