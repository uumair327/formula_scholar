import 'package:flutter/material.dart';

/// Production-safe [Text] wrapper with sensible defaults.
///
/// Automatically applies [TextOverflow.ellipsis] and [softWrap] to prevent
/// layout breaks with long localized strings. Use this instead of raw [Text]
/// for all user-facing strings.
///
/// Features:
/// - Overflow protection (critical for Arabic/Urdu and other dense scripts)
/// - Optional [maxLines] capping for constrained layouts
/// - Small-device scaling via [textScaler] clamp
/// - Full [TextStyle] compatibility via [style]
///
/// Usage:
/// ```dart
/// AppText(AppStrings.welcomeScholar, style: AppTextStyles.titleLarge)
/// AppText('Long text that could overflow', maxLines: 2)
/// ```
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.softWrap = true,
    this.textScaler,
    this.semanticsLabel,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final bool softWrap;
  final TextScaler? textScaler;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaler: textScaler,
      semanticsLabel: semanticsLabel,
    );
  }
}

/// Extension on [BuildContext] to provide device-aware text scaling.
///
/// Clamps the system [MediaQuery.textScaler] to prevent excessively
/// large text on small screens, while still respecting the user's
/// accessibility settings within a safe range.
extension ResponsiveTextScale on BuildContext {
  /// Returns a clamped [TextScaler] (0.8x – 1.3x) for small screens.
  TextScaler get clampedTextScaler {
    // ignore: deprecated_member_use
    final raw = MediaQuery.textScalerOf(this).textScaleFactor;
    return TextScaler.linear(raw.clamp(0.8, 1.3));
  }
}
