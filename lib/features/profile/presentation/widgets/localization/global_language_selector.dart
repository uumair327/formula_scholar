import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/core.dart';
import 'localization_section_card.dart';
import 'localization_helpers.dart';

class GlobalLanguageSelector extends StatelessWidget {
  const GlobalLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final systemLocale = PlatformDispatcher.instance.locale;

    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return LocalizationSectionCard(
          title: l10n.languageAndLocalization,
          subtitle: 'Choose your preferred language for the app interface and content.',
          child: DropdownButtonFormField<String>(
            initialValue: state.effectiveAppLocale(systemLocale).languageCode,
            decoration: const InputDecoration(
              labelText: 'Global Language',
              prefixIcon: Icon(
                Icons.language,
                size: AppDimensions.iconMD,
              ),
            ),
            items: AppLocales.appLabelSupportedLocales.map((locale) {
              return DropdownMenuItem<String>(
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
              );
            }).toList(),
            onChanged: (code) {
              if (code == null) return;
              final cubit = context.read<LocalizationCubit>();
              // Disable system locale override
              cubit.setUseSystemAppLabelLocale(false);
              // Enable both
              cubit.setAppLabelLocalizationEnabled(true);
              cubit.setContentLocalizationEnabled(true);
              // Set App Label
              cubit.setAppLabelLanguageCode(code);
              // Map to Content Locale (e.g. en -> en-IN, ar -> ar-IN)
              final contentCode = switch (code) {
                'ar' => 'ar-IN',
                'ur' => 'ur-IN',
                'en' => 'en-IN',
                _ => '$code-IN', // Fallback
              };
              cubit.setContentLocaleCode(contentCode);
            },
          ),
        );
      },
    );
  }
}
