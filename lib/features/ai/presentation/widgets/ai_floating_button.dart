import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class AiFloatingButton extends StatelessWidget {
  const AiFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open AI Assistant',
      child: FloatingActionButton(
        heroTag: 'ai-assistant-fab',
        tooltip: 'AI Assistant',
        onPressed: () => context.pushNamed(AppRoutes.aiChatName),
        child: const Icon(LucideIcons.sparkles),
      ),
    );
  }
}
