import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/core.dart';
import '../../../../../shared/shared.dart';

class HelpFaqCard extends StatelessWidget {
  const HelpFaqCard({super.key, required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: ThemeData(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingXS,
          ),
          childrenPadding: const EdgeInsets.only(
            left: AppDimensions.paddingXL,
            right: AppDimensions.paddingXL,
            bottom: AppDimensions.paddingLG,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: AppDimensions.avatarSM,
            height: AppDimensions.avatarSM,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(LucideIcons.helpCircle, size: AppDimensions.iconSM, color: colorScheme.primary),
          ),
          title: Text(question, style: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface)),
          children: [
            Text(answer, style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: AppDimensions.lineHeightRelaxed,
            )),
          ],
        ),
      ),
    );
  }
}
