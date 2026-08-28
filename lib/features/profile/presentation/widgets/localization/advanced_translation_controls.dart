import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/core.dart';
import 'localization_section_card.dart';
import 'localization_helpers.dart';

class AdvancedTranslationControls extends StatelessWidget {
  const AdvancedTranslationControls({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final systemLocale = PlatformDispatcher.instance.locale;

    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        final isAppLabelControlsEnabled = state.appLabelLocalizationEnabled;
        final isContentControlsEnabled = state.contentLocalizationEnabled;

        return ExpansionTile(
          title: Text(
            'Advanced Translation Customization',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Granular controls for app labels and content',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          ),
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          collapsedBackgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
          childrenPadding: const EdgeInsets.all(AppDimensions.paddingLG),
          children: [
            LocalizationSectionCard(
              title: l10n.labelsLocalizationTitle,
              subtitle: l10n.labelsLocalizationSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.enableLabelsLocalization,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(l10n.enableLabelsLocalizationDesc),
                    value: state.appLabelLocalizationEnabled,
                    onChanged: (v) => context.read<LocalizationCubit>().setAppLabelLocalizationEnabled(v),
                  ),
                  const SizedBox(height: AppDimensions.paddingSM),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.useSystemLanguage,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${l10n.currentSystemLanguage}: ${LocalizationHelpers.displayLabelLanguageName(context, systemLocale.languageCode)}',
                    ),
                    value: state.useSystemAppLabelLocale && isAppLabelControlsEnabled,
                    onChanged: isAppLabelControlsEnabled
                        ? (v) => context.read<LocalizationCubit>().setUseSystemAppLabelLocale(v)
                        : null,
                  ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  DropdownButtonFormField<String>(
                    initialValue: state.appLabelLanguageCode,
                    decoration: InputDecoration(
                      labelText: l10n.appLabelLanguage,
                      prefixIcon: const Icon(Icons.translate, size: AppDimensions.iconMD),
                    ),
                    items: AppLocales.appLabelSupportedLocales
                        .map(
                          (locale) => DropdownMenuItem<String>(
                            value: locale.languageCode,
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    LocalizationHelpers.languageAbbreviation(locale.languageCode),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.paddingMD),
                                Text(
                                  LocalizationHelpers.displayLabelLanguageName(context, locale.languageCode),
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (!isAppLabelControlsEnabled || state.useSystemAppLabelLocale)
                        ? null
                        : (code) {
                            if (code == null) return;
                            context.read<LocalizationCubit>().setAppLabelLanguageCode(code);
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            LocalizationSectionCard(
              title: l10n.contentLocalizationTitle,
              subtitle: l10n.contentLocalizationSubtitle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.enableContentLocalization,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(l10n.enableContentLocalizationDesc),
                    value: state.contentLocalizationEnabled,
                    onChanged: (v) => context.read<LocalizationCubit>().setContentLocalizationEnabled(v),
                  ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  DropdownButtonFormField<String>(
                    initialValue: AppLocales.normalizeContentLocaleCode(state.contentLocaleCode),
                    decoration: InputDecoration(
                      labelText: l10n.contentLanguage,
                      prefixIcon: const Icon(LucideIcons.globe, size: AppDimensions.iconMD),
                    ),
                    items: AppLocales.contentSupportedLocaleCodes
                        .map(
                          (code) => DropdownMenuItem<String>(
                            value: code,
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondaryContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    LocalizationHelpers.languageAbbreviation(code),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: colorScheme.onSecondaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppDimensions.paddingMD),
                                Text(
                                  LocalizationHelpers.displayContentLanguageName(context, code),
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: !isContentControlsEnabled
                        ? null
                        : (code) {
                            if (code == null) return;
                            context.read<LocalizationCubit>().setContentLocaleCode(code);
                          },
                  ),
                  const SizedBox(height: AppDimensions.paddingLG),
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingMD),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                      border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.info, size: AppDimensions.iconSM, color: colorScheme.outline),
                        const SizedBox(width: AppDimensions.paddingSM),
                        Expanded(
                          child: Text(
                            l10n.contentLocalizationFallbackInfo,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
