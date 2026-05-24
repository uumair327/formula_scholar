import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import 'glass_bottom_nav_bar.dart';

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
          padding: const EdgeInsets.only(
            left: AppDimensions.paddingXL,
            right: AppDimensions.paddingXL,
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
