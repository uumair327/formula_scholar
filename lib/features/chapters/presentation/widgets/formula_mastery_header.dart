import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../cubit/formulas_state.dart';

class FormulaMasteryHeader extends StatelessWidget {
  const FormulaMasteryHeader({super.key, required this.state});
  final FormulasState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allMastered = state.masteredCount == state.totalCount && state.totalCount > 0;

    return Row(
      children: [
        Icon(
          allMastered ? LucideIcons.checkCircle2 : LucideIcons.graduationCap,
          size: AppDimensions.iconXS,
          color: allMastered ? AppColors.secondary : colorScheme.outline,
        ),
        const SizedBox(width: AppDimensions.paddingXS),
        Text(
          state.totalCount > 0
              ? '${state.masteredCount} of ${state.totalCount} mastered'
              : 'No formulas',
          style: AppTextStyles.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (state.totalCount > 0) ...[
          const SizedBox(width: AppDimensions.paddingSM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingSM,
              vertical: AppDimensions.paddingXXS,
            ),
            decoration: BoxDecoration(
              color: state.progressPercent == 100
                  ? AppColors.secondaryFixed
                  : colorScheme.primaryFixed,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: Text(
              '${state.progressPercent.toInt()}%',
              style: AppTextStyles.overline.copyWith(
                color: state.progressPercent == 100
                    ? AppColors.secondary
                    : colorScheme.primary,
                fontSize: AppDimensions.fontSizeXS,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
