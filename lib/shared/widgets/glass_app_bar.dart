import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable frosted-glass app bar for a consistent premium look.
///
/// Uses [BackdropFilter] to blur the content behind the app bar,
/// producing a glassmorphism effect. Works in both light and dark mode.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.bottom,
    this.elevation = 0.0,
    this.toolbarHeight = kToolbarHeight,
  });

  /// Simple string title.
  final String? title;

  /// Custom title widget (overrides [title]).
  final Widget? titleWidget;

  /// Trailing action buttons.
  final List<Widget>? actions;

  /// Leading widget.
  final Widget? leading;

  /// Whether to show the back button automatically.
  final bool automaticallyImplyLeading;

  /// Optional bottom widget (e.g., TabBar).
  final PreferredSizeWidget? bottom;

  /// Shadow elevation.
  final double elevation;

  /// Toolbar height.
  final double toolbarHeight;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: Colors.transparent, // Let flexibleSpace handle the background
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      leading: leading,
      title: titleWidget ??
          (title != null
              ? AppText(
                  title!,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  softWrap: false,
                )
              : null),
      actions: actions,
      bottom: bottom,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppDimensions.glassBlurSigma,
            sigmaY: AppDimensions.glassBlurSigma,
          ),
          child: Container(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
          ),
        ),
      ),
    );
  }
}

/// Sliver variant of [GlassAppBar] for use in [CustomScrollView].
class SliverGlassAppBar extends StatelessWidget {
  const SliverGlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.floating = true,
    this.snap = true,
    this.pinned = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.toolbarHeight = kToolbarHeight,
  });

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool floating;
  final bool snap;
  final bool pinned;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      floating: floating,
      snap: snap,
      pinned: pinned,
      expandedHeight: expandedHeight,
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: titleWidget ??
          (title != null
              ? AppText(
                  title!,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  softWrap: false,
                )
              : null),
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppDimensions.glassBlurSigma,
            sigmaY: AppDimensions.glassBlurSigma,
          ),
          child: Container(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
            child: flexibleSpace,
          ),
        ),
      ),
    );
  }
}
