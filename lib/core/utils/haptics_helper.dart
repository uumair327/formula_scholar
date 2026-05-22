import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Centralized utility for haptic feedback.
class HapticsHelper {
  const HapticsHelper._();

  /// Very subtle vibration for minor interactions (like list scrolling ticks).
  static void selectionClick() {
    if (kIsWeb) return;
    HapticFeedback.selectionClick();
  }

  /// Light vibration for standard button taps or toggles.
  static void lightImpact() {
    if (kIsWeb) return;
    HapticFeedback.lightImpact();
  }

  /// Medium vibration for important actions.
  static void mediumImpact() {
    if (kIsWeb) return;
    HapticFeedback.mediumImpact();
  }

  /// Heavy vibration for destructive actions or major state changes.
  static void heavyImpact() {
    if (kIsWeb) return;
    HapticFeedback.heavyImpact();
  }
}
