import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/core.dart';

class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.breakpointDesktop) {
          return DesktopShell(navigationShell: navigationShell);
        }
        return MobileShell(navigationShell: navigationShell);
      },
    );
  }
}
