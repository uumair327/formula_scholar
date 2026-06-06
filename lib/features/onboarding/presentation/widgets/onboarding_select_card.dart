import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';

class OnboardingSelectCard extends StatefulWidget {
  const OnboardingSelectCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<OnboardingSelectCard> createState() => _OnboardingSelectCardState();
}

class _OnboardingSelectCardState extends State<OnboardingSelectCard> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) =>
      setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: AppDurations.animationFast,
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          padding: const EdgeInsets.all(AppDimensions.paddingXXL),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? (isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.08)
                      : AppColors.primaryFixed.withValues(alpha: 0.08))
                : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary.withValues(
                      alpha: AppDimensions.opacityMedium,
                    )
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: widget.isSelected
                  ? AppDimensions.borderWidthThick
                  : AppDimensions.borderWidth,
            ),
            boxShadow: widget.isSelected
                ? [AppShadows.glow(AppColors.primary)]
                : const [AppShadows.subtle],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.icon,
                  const SizedBox(height: AppDimensions.paddingXL),
                  Text(
                    widget.title,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    widget.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (widget.isSelected)
                Positioned(
                  top: 0,
                  left: Directionality.of(context) == TextDirection.rtl
                      ? 0
                      : null,
                  right: Directionality.of(context) == TextDirection.ltr
                      ? 0
                      : null,
                  child: Container(
                    width: AppDimensions.iconMD,
                    height: AppDimensions.iconMD,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDark
                          ? AppColors.darkPrimaryGradient
                          : AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      LucideIcons.check,
                      size: AppDimensions.iconSM,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
