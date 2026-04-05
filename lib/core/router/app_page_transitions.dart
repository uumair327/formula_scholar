import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_durations.dart';

/// Custom page transitions for [GoRouter] routes.
///
/// Centralizes all transition animations to ensure consistent
/// motion design across the app. Each factory method returns a
/// [CustomTransitionPage] that can be used in GoRoute's `pageBuilder`.
abstract final class AppPageTransitions {
  /// Fade transition – used for top-level tab routes within [StatefulShellRoute].
  ///
  /// Provides a smooth crossfade when switching between bottom nav tabs.
  static CustomTransitionPage<void> fadeTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: AppDurations.animationDefault,
      reverseTransitionDuration: AppDurations.animationDefault,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(
            curve: AppDurations.curveDefault,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  /// Slide-up transition – used for detail pages pushed on top of the shell.
  ///
  /// Creates a modal-style upward slide with a fade, suitable for
  /// sub-pages like topic details, formula details, etc.
  static CustomTransitionPage<void> slideUpTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: AppDurations.animationDefault,
      reverseTransitionDuration: AppDurations.animationDefault,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurveTween(
          curve: AppDurations.curveDefault,
        ).animate(animation);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }

  /// Slide-right transition – standard forward navigation feel.
  ///
  /// Used for linear navigation flows (e.g. drill-down into topic → subtopic).
  static CustomTransitionPage<void> slideRightTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      name: state.name,
      child: child,
      transitionDuration: AppDurations.animationDefault,
      reverseTransitionDuration: AppDurations.animationDefault,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurveTween(
          curve: AppDurations.curveDefault,
        ).animate(animation);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.25, 0),
            end: Offset.zero,
          ).animate(curved),
          child: FadeTransition(opacity: curved, child: child),
        );
      },
    );
  }
}
