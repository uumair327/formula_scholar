import 'package:flutter/animation.dart';

/// Centralized animation duration and curve constants.
///
/// Provides a single source of truth for all timing-related values.
/// Grouping durations with their default curves ensures consistent
/// motion design across the entire application.
abstract final class AppDurations {
  // ──────────────────────── Durations ─────────────────────────
  /// Instant interactions – micro-feedback like ripple, opacity toggle.
  static const Duration instant = Duration(milliseconds: 100);

  /// Fast animations – switches, chips, small state changes.
  static const Duration animationFast = Duration(milliseconds: 200);

  /// Default animations – container transitions, nav bar changes.
  static const Duration animationDefault = Duration(milliseconds: 300);

  /// Slow animations – page transitions, hero animations.
  static const Duration animationSlow = Duration(milliseconds: 450);

  /// Extra-slow animations – onboarding reveals, complex sequences.
  static const Duration animationXSlow = Duration(milliseconds: 600);

  // ──────────────────────── Delays ────────────────────────────
  /// Short simulated delay – loading spinners, skeleton screens.
  static const Duration delayShort = Duration(milliseconds: 500);

  /// Medium simulated delay – data fetch simulation.
  static const Duration delayMedium = Duration(seconds: 1);

  /// Long simulated delay – heavy operations.
  static const Duration delayLong = Duration(seconds: 2);

  // ──────────────────────── Debounce / Throttle ──────────────
  /// Search input debounce.
  static const Duration debounceDefault = Duration(milliseconds: 350);

  /// Scroll throttle.
  static const Duration throttleDefault = Duration(milliseconds: 150);

  // ──────────────────────── Curves ────────────────────────────
  /// Default easing – general-purpose smooth motion.
  static const Curve curveDefault = Curves.easeInOut;

  /// Bounce-back easing – playful nav bar / tab transitions.
  static const Curve curveEaseOutBack = Curves.easeOutBack;

  /// Decelerate easing – elements entering the screen.
  static const Curve curveDecelerate = Curves.decelerate;

  /// Accelerate easing – elements leaving the screen.
  static const Curve curveAccelerate = Curves.easeIn;

  /// Elastic easing – attention-grabbing emphasis animations.
  static const Curve curveElastic = Curves.elasticOut;
}
