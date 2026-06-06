import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../domain/domain.dart';

class CurriculumCard extends StatefulWidget {
  const CurriculumCard({
    super.key,
    required this.board,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    required this.color,
  });
  final Board board;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final Color color;

  @override
  State<CurriculumCard> createState() => _CurriculumCardState();
}

class _CurriculumCardState extends State<CurriculumCard> {
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
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: widget.isSelected
                  ? AppDimensions.borderWidthThick
                  : AppDimensions.borderWidth,
            ),
            boxShadow: const [AppShadows.subtle],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: AppDurations.animationFast,
                    width: AppDimensions.avatarLG,
                    height: AppDimensions.avatarLG,
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? widget.color
                          : widget.color.withValues(
                              alpha: AppDimensions.opacityFaint,
                            ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMD,
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: AppDimensions.iconLG,
                      color: widget.isSelected
                          ? AppColors.onPrimary
                          : widget.color,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),
                  Text(
                    widget.board.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXXS),
                  Text(
                    widget.board.description,
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
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                    ),
                    child: const Icon(
                      LucideIcons.checkCircle2,
                      size: AppDimensions.iconDefault,
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
