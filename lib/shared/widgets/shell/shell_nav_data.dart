import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../l10n/l10n.dart';

class NavItemData {
  const NavItemData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

List<NavItemData> navItems(BuildContext context) {
  final l10n = context.l10n;
  return [
    NavItemData(icon: LucideIcons.home, label: l10n.navHome),
    NavItemData(icon: LucideIcons.layers, label: l10n.navSubjects),
    NavItemData(icon: LucideIcons.gamepad2, label: l10n.navPractice),
    NavItemData(icon: LucideIcons.bookmark, label: l10n.navSaved),
    NavItemData(icon: LucideIcons.user, label: l10n.navProfile),
  ];
}
