import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import 'ai_floating_button.dart';

import 'package:go_router/go_router.dart';

class AiAssistantOverlay extends StatefulWidget {
  const AiAssistantOverlay({
    super.key,
    required this.child,
    required this.bottomOffset,
  });

  final Widget child;
  final double bottomOffset;

  @override
  State<AiAssistantOverlay> createState() => _AiAssistantOverlayState();
}

class _AiAssistantOverlayState extends State<AiAssistantOverlay> {
  RouterDelegate? _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newDelegate = GoRouter.of(context).routerDelegate;
    if (_routerDelegate != newDelegate) {
      _routerDelegate?.removeListener(_onRouteChanged);
      _routerDelegate = newDelegate;
      _routerDelegate?.addListener(_onRouteChanged);
    }
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    final path = GoRouter.of(context).routerDelegate.currentConfiguration.uri.path;
    if (path.contains('study-planner')) {
      FabVisibilityManager.fabOffset.value = 80.0;
    } else if (path.contains('subject-chapters')) {
      FabVisibilityManager.fabOffset.value = FabVisibilityManager.hasSubjectSelection ? 80.0 : 0.0;
    } else {
      FabVisibilityManager.fabOffset.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        ValueListenableBuilder<double>(
          valueListenable: FabVisibilityManager.fabOffset,
          builder: (context, offset, child) {
            return AnimatedPositionedDirectional(
              duration: AppDurations.animationFast,
              curve: AppDurations.curvePremium,
              end: AppDimensions.paddingLG,
              bottom: widget.bottomOffset + offset,
              child: const AiFloatingButton(),
            );
          },
        ),
      ],
    );
  }
}
