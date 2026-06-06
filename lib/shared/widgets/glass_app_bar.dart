import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

class _PremiumBackButton extends StatelessWidget {
  const _PremiumBackButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.paddingXS),
            child: Icon(
              isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
              color: colorScheme.onSurface,
              size: AppDimensions.iconMD,
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget>? _padActions(List<Widget>? actions) {
  if (actions == null || actions.isEmpty) return null;
  return [...actions, const SizedBox(width: AppDimensions.paddingMD)];
}

Widget _buildFlexibleSpace(BuildContext context, Widget? child) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return ClipRect(
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: AppDimensions.glassBlurSigma,
        sigmaY: AppDimensions.glassBlurSigma,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.glassDark : AppColors.glassLight,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
        ),
        child: child,
      ),
    ),
  );
}

/// Reusable frosted-glass app bar for a consistent premium look.
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

  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final double toolbarHeight;

  @override
  Size get preferredSize =>
      Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? actualLeading = leading;
    if (actualLeading == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      if (canPop) {
        actualLeading = const _PremiumBackButton();
      }
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: elevation,
      automaticallyImplyLeading:
          false, // We handle it manually for the custom icon
      toolbarHeight: toolbarHeight,
      leading: actualLeading,
      title:
          titleWidget ??
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
      actions: _padActions(actions),
      bottom: bottom,
      flexibleSpace: _buildFlexibleSpace(context, null),
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
    this.bottom,
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
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final double toolbarHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? actualLeading = leading;
    if (actualLeading == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      if (canPop) {
        actualLeading = const _PremiumBackButton();
      }
    }

    return SliverAppBar(
      floating: floating,
      snap: snap,
      pinned: pinned,
      expandedHeight: expandedHeight,
      toolbarHeight: toolbarHeight,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: actualLeading,
      title:
          titleWidget ??
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
      actions: _padActions(actions),
      bottom: bottom,
      flexibleSpace: _buildFlexibleSpace(context, flexibleSpace),
    );
  }
}
