import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import 'ai_floating_button.dart';

class AiAssistantOverlay extends StatelessWidget {
  const AiAssistantOverlay({
    super.key,
    required this.child,
    required this.bottomOffset,
  });

  final Widget child;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          end: AppDimensions.paddingLG,
          bottom: bottomOffset,
          child: const AiFloatingButton(),
        ),
      ],
    );
  }
}
