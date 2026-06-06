library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../profile/profile.dart';
import '../cubit/curriculum_options_cubit.dart';
import 'curriculum_selection_bottom_sheet.dart';

/// Revamped dashboard app bar with a Duolingo-style curriculum selector
/// button on the left and user stats (streak, XP, formulas) on the right.
///
/// Uses the exact same [BlocBuilder] → [SliverGlassAppBar(titleWidget:)]
/// pattern as the original working code to stay layout-safe inside slivers.
class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap in BlocBuilder<ProfileCubit> to reactively show user stats.
    // This mirrors the original BlocBuilder<AuthCubit> wrapping pattern
    // which is proven to work inside CustomScrollView slivers.
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (prev, curr) => prev.stats != curr.stats,
      builder: (context, profileState) {
        final stats = profileState.stats;
        final streak =
            stats.where((s) => s.id == 'streak').firstOrNull?.value ?? '0';
        final points =
            stats.where((s) => s.id == 'points').firstOrNull?.value ?? '0';
        final formulas =
            stats.where((s) => s.id == 'formulas').firstOrNull?.value ?? '0';

        return SliverGlassAppBar(
          titleWidget: Row(
            children: [
              _CurriculumButton(
                onTap: () {
                  HapticsHelper.lightImpact();
                  showCurriculumSelectionBottomSheet(
                    context,
                    optionsCubit: context.read<CurriculumOptionsCubit>(),
                  );
                },
              ),
              const Spacer(),
              _StatBadge(
                icon: LucideIcons.flame,
                value: streak,
                iconColor: Colors.orangeAccent,
                onTap: () => _showStatMessage(
                  context,
                  'You are on a $streak-day streak! Keep it up! 🔥',
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXXS),
              _StatBadge(
                icon: LucideIcons.sparkles,
                value: points,
                iconColor: Colors.cyan,
                onTap: () => _showStatMessage(
                  context,
                  '$points XP earned. Keep practicing! 🌟',
                ),
              ),
              const SizedBox(width: AppDimensions.paddingXXS),
              _StatBadge(
                icon: LucideIcons.award,
                value: formulas,
                iconColor: Colors.purpleAccent,
                onTap: () => _showStatMessage(
                  context,
                  '$formulas formulas mastered! 🏆',
                ),
              ),
            ],
          ),
          bottom: const DummySearchPill(),
        );
      },
    );
  }

  void _showStatMessage(BuildContext context, String message) {
    HapticsHelper.lightImpact();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onInverseSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(AppDimensions.paddingLG),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
      ),
    );
  }
}

// ────────────────────────── Curriculum Button ─────────────────────────────

/// Near-square Duolingo-style button showing a 2×2 math operator grid.
class _CurriculumButton extends StatelessWidget {
  const _CurriculumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Select curriculum',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          child: Container(
            width: 44,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: _MathGridIcon(colorScheme: colorScheme),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────── Math Grid Icon ────────────────────────────────

/// Compact 2×2 grid of math operators: + − × ÷
class _MathGridIcon extends StatelessWidget {
  const _MathGridIcon({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const double fontSize = 12;
    const fontWeight = FontWeight.w900;
    const double height = 1.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: fontSize,
                fontWeight: fontWeight,
                height: height,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Text(
              '−',
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: fontSize,
                fontWeight: fontWeight,
                height: height,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingXXS),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '×',
              style: TextStyle(
                color: colorScheme.tertiary,
                fontSize: fontSize,
                fontWeight: fontWeight,
                height: height,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingXS),
            Text(
              '÷',
              style: TextStyle(
                color: colorScheme.error,
                fontSize: fontSize,
                fontWeight: fontWeight,
                height: height,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ────────────────────────── Stat Badge ────────────────────────────────────

/// Compact tappable badge showing an icon + numeric value.
class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSM,
            vertical: AppDimensions.paddingXS,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppDimensions.iconMD, color: iconColor),
              const SizedBox(width: AppDimensions.paddingXS),
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimensions.fontSizeSM,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
