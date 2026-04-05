import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Maps string icon identifiers to [IconData] from Lucide Icons.
///
/// This utility follows the Open/Closed Principle — to support a new
/// icon, simply add an entry to the map. No widget code changes needed.
///
/// Used by dashboard subject cards, recent study items, and any other
/// data-driven UI that receives icon identifiers from the backend.
abstract final class AppIconMapper {
  static const Map<String, IconData> _icons = {
    'calculator': LucideIcons.calculator,
    'rocket': LucideIcons.rocket,
    'flask-conical': LucideIcons.flaskConical,
    'microscope': LucideIcons.microscope,
    'atom': LucideIcons.atom,
    'book-open': LucideIcons.bookOpen,
    'brain': LucideIcons.brain,
    'code': LucideIcons.code,
    'globe': LucideIcons.globe,
    'palette': LucideIcons.palette,
    'music': LucideIcons.music,
    'dumbbell': LucideIcons.dumbbell,
    'laptop': LucideIcons.laptop,
    'pencil': LucideIcons.pencil,
    'lightbulb': LucideIcons.lightbulb,
    'leaf': LucideIcons.leaf,
    'compass': LucideIcons.compass,
    'ruler': LucideIcons.ruler,
    'star': LucideIcons.star,
  };

  /// Resolves a string icon name to [IconData].
  /// Falls back to [LucideIcons.bookOpen] for unknown names.
  static IconData resolve(String iconName) {
    return _icons[iconName] ?? LucideIcons.bookOpen;
  }
}
