import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../widget_viewer/presentation/widgets/interactive_widget_container.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.role == AiMessageRole.user;

    final bubbleDecoration = BoxDecoration(
      gradient: isUser
          ? LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isUser ? null : colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(AppDimensions.radiusLG),
        topRight: const Radius.circular(AppDimensions.radiusLG),
        bottomLeft: Radius.circular(
          isUser ? AppDimensions.radiusLG : AppDimensions.radiusXS,
        ),
        bottomRight: Radius.circular(
          isUser ? AppDimensions.radiusXS : AppDimensions.radiusLG,
        ),
      ),
      border: isUser
          ? null
          : Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.15),
            ),
      boxShadow: [
        isUser
            ? BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              )
            : AppShadows.subtle,
      ],
    );

    final foregroundColor = isUser ? AppColors.white : colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXS),
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: bubbleDecoration,
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
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMD,
                        ),
                      ),
                      child: IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: 'Read aloud',
                        onPressed: () => onSpeak(message.content),
                        icon: Icon(
                          Icons.volume_up,
                          size: AppDimensions.iconSM,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    if (message.actionRequest != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: AppDimensions.paddingSM,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingMD,
                            vertical: AppDimensions.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer.withValues(
                              alpha: isDark ? 0.3 : 0.8,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusXL,
                            ),
                            border: Border.all(
                              color: colorScheme.secondary.withValues(
                                alpha: 0.2,
                              ),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.checkCircle,
                                size: AppDimensions.iconXS,
                                color: colorScheme.secondary,
                              ),
                              const SizedBox(width: AppDimensions.paddingXS),
                              Text(
                                message.actionRequest!.action,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              if (message.widgetConfig != null) ...[
                const SizedBox(height: AppDimensions.paddingMD),
                InteractiveWidgetContainer(widgetConfig: message.widgetConfig!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
