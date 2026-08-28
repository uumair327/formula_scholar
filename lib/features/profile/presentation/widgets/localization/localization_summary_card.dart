import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/core.dart';
import 'localization_helpers.dart';

class LocalizationSummaryCard extends StatelessWidget {
  const LocalizationSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final systemLocale = PlatformDispatcher.instance.locale;

    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return AppGlassCard(
          borderRadius: AppDimensions.radiusLG,
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle,
                    color: AppColors.secondary,
                    size: AppDimensions.iconMD,
                  ),
                  const SizedBox(width: AppDimensions.paddingMD),
                  Text(
                    l10n.localizationEffectiveSummary,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingLG),
              const Divider(height: 1),
              const SizedBox(height: AppDimensions.paddingLG),
              _SummaryRow(
                icon: Icons.translate,
                label: l10n.appLabels,
                symbol: LocalizationHelpers.languageAbbreviation(
                  state.effectiveAppLocale(systemLocale).languageCode,
                ),
                value: LocalizationHelpers.displayLabelLanguageName(
                  context,
                  state.effectiveAppLocale(systemLocale).languageCode,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              _SummaryRow(
                icon: LucideIcons.globe,
                label: l10n.backendContent,
                symbol: LocalizationHelpers.languageAbbreviation(
                  state.effectiveContentLocaleCode,
                ),
                value: LocalizationHelpers.displayContentLanguageName(
                  context,
                  state.effectiveContentLocaleCode,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.symbol,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String symbol;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: AppDimensions.iconSM, color: colorScheme.outline),
        const SizedBox(width: AppDimensions.paddingMD),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingSM,
            vertical: AppDimensions.paddingXS,
          ),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          ),
          child: Text(
            symbol,
            style: AppTextStyles.labelSmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingXS),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
