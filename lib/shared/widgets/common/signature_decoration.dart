import 'package:flutter/material.dart';

import '../../../core/core.dart';

BoxDecoration signatureGlowDecoration(ColorScheme colorScheme) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colorScheme.primary,
        colorScheme.primaryContainer,
      ],
    ),
    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
    boxShadow: [AppShadows.glow(colorScheme.primary)],
  );
}

BoxDecoration ghostShadowDecoration({
  required Color color,
  double borderRadius = AppDimensions.radiusLG,
}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: const [AppShadows.ghost],
  );
}
