import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/core.dart';

class NavItemData {
  const NavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

const List<NavItemData> navItems = [
  NavItemData(icon: LucideIcons.home, label: AppStrings.navHome),
  NavItemData(icon: LucideIcons.layers, label: AppStrings.navSubjects),
  NavItemData(icon: LucideIcons.gamepad2, label: AppStrings.navPractice),
  NavItemData(icon: LucideIcons.bookmark, label: AppStrings.navSaved),
  NavItemData(icon: LucideIcons.user, label: AppStrings.navProfile),
];
