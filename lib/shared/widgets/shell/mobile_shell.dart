import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';

class MobileShell extends StatelessWidget {
  const MobileShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimensions.paddingXL,
            end: AppDimensions.paddingXL,
            bottom: AppDimensions.paddingLG,
          ),
          child: GlassBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) {
              HapticsHelper.lightImpact();
              navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
            },
          ),
        ),
      ),
    );
  }
}
