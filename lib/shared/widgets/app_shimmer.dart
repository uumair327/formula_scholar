import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/core.dart';

/// A single shimmer placeholder box with configurable size and shape.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppDimensions.radiusMD,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Wraps children in a [Shimmer] effect using theme-aware colors.
class AppShimmer extends StatelessWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.surfaceContainerHigh,
      highlightColor: isDark
          ? colorScheme.surfaceContainerHigh
          : colorScheme.surfaceContainerLowest,
      child: child,
    );
  }
}

/// Dashboard loading skeleton — hero card + subject grid + recent studies.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar placeholder
              const Row(
                children: [
                  ShimmerBox(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    borderRadius: AppDimensions.radiusXXL,
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 14),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 80, height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Hero status card
              const ShimmerBox(
                width: double.infinity,
                height: 160,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingSection),
              // Section header
              const ShimmerBox(width: 140, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              // Subject grid (2x2)
              const Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              const Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingSection),
              // Continue studying section header
              const ShimmerBox(width: 160, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              // Recent study cards
              for (int i = 0; i < 3; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 72,
                  borderRadius: AppDimensions.radiusLG,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Chapters loading skeleton — subject chips + chapter list.
class ChaptersShimmer extends StatelessWidget {
  const ChaptersShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingLG,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured chapter card
            const ShimmerBox(
              width: double.infinity,
              height: 140,
              borderRadius: AppDimensions.radiusXL,
            ),
            const SizedBox(height: AppDimensions.paddingXXL),
            // Section header
            const ShimmerBox(width: 120, height: 16),
            const SizedBox(height: AppDimensions.paddingLG),
            // Chapter list
            for (int i = 0; i < 5; i++) ...[
              const ShimmerBox(
                width: double.infinity,
                height: 80,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ],
        ),
      ),
    );
  }
}

/// Profile loading skeleton — hero card + stats grid + settings.
class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar placeholder
              const Row(
                children: [
                  ShimmerBox(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    borderRadius: AppDimensions.radiusXXL,
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 150, height: 16),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 100, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Hero profile card
              const ShimmerBox(
                width: double.infinity,
                height: 140,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              // Stats section header
              const ShimmerBox(width: 120, height: 16),
              const SizedBox(height: AppDimensions.paddingLG),
              // Stats grid
              const Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: ShimmerBox(
                      width: double.infinity,
                      height: 100,
                      borderRadius: AppDimensions.radiusLG,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              const ShimmerBox(
                width: double.infinity,
                height: 100,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              // Settings section header
              const ShimmerBox(width: 80, height: 16),
              const SizedBox(height: AppDimensions.paddingLG),
              // Settings items
              for (int i = 0; i < 5; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 52,
                  borderRadius: AppDimensions.radiusMD,
                ),
                const SizedBox(height: AppDimensions.paddingSM),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Saved/Bookmarks loading skeleton — tabs + list items.
class SavedShimmer extends StatelessWidget {
  const SavedShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppShimmer(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  ShimmerBox(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    borderRadius: AppDimensions.radiusXXL,
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 120, height: 16),
                        SizedBox(height: AppDimensions.paddingSM),
                        ShimmerBox(width: 80, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Search bar
              const ShimmerBox(
                width: double.infinity,
                height: 48,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              // Tab bar
              const Row(
                children: [
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                  SizedBox(width: AppDimensions.paddingMD),
                  Expanded(child: ShimmerBox(width: 80, height: 36)),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Bookmark items
              for (int i = 0; i < 6; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 80,
                  borderRadius: AppDimensions.radiusLG,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Formulas loading skeleton — list of formula cards.
class FormulasShimmer extends StatelessWidget {
  const FormulasShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < 5; i++) ...[
              const ShimmerBox(
                width: double.infinity,
                height: 120,
                borderRadius: AppDimensions.radiusLG,
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ],
        ),
      ),
    );
  }
}

/// Practice loading skeleton — quiz card layout.
class PracticeShimmer extends StatelessWidget {
  const PracticeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.paddingXXL),
              // App bar title area
              const ShimmerBox(
                width: 140,
                height: 24,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              // Progress bar
              const ShimmerBox(
                width: double.infinity,
                height: 8,
                borderRadius: AppDimensions.radiusMD,
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              // Question card
              const ShimmerBox(
                width: double.infinity,
                height: 200,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Options
              for (int i = 0; i < 4; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 60,
                  borderRadius: AppDimensions.radiusLG,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Notifications loading skeleton.
class NotificationsShimmer extends StatelessWidget {
  const NotificationsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar
              const Row(
                children: [
                  ShimmerBox(
                    width: AppDimensions.avatarMD,
                    height: AppDimensions.avatarMD,
                    borderRadius: AppDimensions.radiusXXL,
                  ),
                  SizedBox(width: AppDimensions.paddingMD),
                  ShimmerBox(width: 150, height: 24),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Status Card
              const ShimmerBox(
                width: double.infinity,
                height: 100,
                borderRadius: AppDimensions.radiusXL,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Section Header
              const ShimmerBox(width: 180, height: 18),
              const SizedBox(height: AppDimensions.paddingLG),
              // Setting items
              for (int i = 0; i < 4; i++) ...[
                const ShimmerBox(
                  width: double.infinity,
                  height: 70,
                  borderRadius: AppDimensions.radiusLG,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
