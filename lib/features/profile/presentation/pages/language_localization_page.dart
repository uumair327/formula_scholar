import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';

class LanguageLocalizationPage extends StatelessWidget {
  const LanguageLocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        final systemLocale = PlatformDispatcher.instance.locale;
        final isAppLabelControlsEnabled = state.appLabelLocalizationEnabled;
        final isContentControlsEnabled = state.contentLocalizationEnabled;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.value(
                    context: context,
                    mobile: AppDimensions.paddingXL,
                    desktop:
                        AppDimensions.paddingSectionLG * 2 +
                        AppDimensions.paddingXL,
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingXXL),
                    EntranceWrapper.stagger(
                      index: 0,
                      child: _SectionCard(
                        title: AppStrings.labelsLocalizationTitle,
                        subtitle: AppStrings.labelsLocalizationSubtitle,
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                AppStrings.enableLabelsLocalization,
                              ),
                              subtitle: const Text(
                                AppStrings.enableLabelsLocalizationDesc,
                              ),
                              value: state.appLabelLocalizationEnabled,
                              onChanged: (v) => context
                                  .read<LocalizationCubit>()
                                  .setAppLabelLocalizationEnabled(v),
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(AppStrings.useSystemLanguage),
                              subtitle: Text(
                                '${AppStrings.currentSystemLanguage}: ${_displayLabelLanguageName(systemLocale.languageCode)}',
                              ),
                              value:
                                  state.useSystemAppLabelLocale &&
                                  isAppLabelControlsEnabled,
                              onChanged: isAppLabelControlsEnabled
                                  ? (v) => context
                                        .read<LocalizationCubit>()
                                        .setUseSystemAppLabelLocale(v)
                                  : null,
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            DropdownButtonFormField<String>(
                              initialValue: state.appLabelLanguageCode,
                              decoration: const InputDecoration(
                                labelText: AppStrings.appLabelLanguage,
                                border: OutlineInputBorder(),
                              ),
                              items: AppLocales.appLabelSupportedLocales
                                  .map(
                                    (locale) => DropdownMenuItem<String>(
                                      value: locale.languageCode,
                                      child: Text(
                                        _displayLabelLanguageName(
                                          locale.languageCode,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged:
                                  (!isAppLabelControlsEnabled ||
                                      state.useSystemAppLabelLocale)
                                  ? null
                                  : (code) {
                                      if (code == null) return;
                                      context
                                          .read<LocalizationCubit>()
                                          .setAppLabelLanguageCode(code);
                                    },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    EntranceWrapper.stagger(
                      index: 1,
                      child: _SectionCard(
                        title: AppStrings.contentLocalizationTitle,
                        subtitle: AppStrings.contentLocalizationSubtitle,
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                AppStrings.enableContentLocalization,
                              ),
                              subtitle: const Text(
                                AppStrings.enableContentLocalizationDesc,
                              ),
                              value: state.contentLocalizationEnabled,
                              onChanged: (v) => context
                                  .read<LocalizationCubit>()
                                  .setContentLocalizationEnabled(v),
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            DropdownButtonFormField<String>(
                              initialValue:
                                  AppLocales.normalizeContentLocaleCode(
                                    state.contentLocaleCode,
                                  ),
                              decoration: const InputDecoration(
                                labelText: AppStrings.contentLanguage,
                                border: OutlineInputBorder(),
                              ),
                              items: AppLocales.contentSupportedLocaleCodes
                                  .map(
                                    (code) => DropdownMenuItem<String>(
                                      value: code,
                                      child: Text(
                                        _displayContentLanguageName(code),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: !isContentControlsEnabled
                                  ? null
                                  : (code) {
                                      if (code == null) return;
                                      context
                                          .read<LocalizationCubit>()
                                          .setContentLocaleCode(code);
                                    },
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            Text(
                              AppStrings.contentLocalizationFallbackInfo,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    EntranceWrapper.stagger(
                      index: 2,
                      child: _SectionCard(
                        title: AppStrings.localizationEffectiveSummary,
                        subtitle:
                            '${AppStrings.appLabels}: ${_displayLabelLanguageName(state.effectiveAppLocale(systemLocale).languageCode)}\n${AppStrings.backendContent}: ${_displayContentLanguageName(state.effectiveContentLocaleCode)}',
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.bottomNavPadding),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverGlassAppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliverGlassAppBar(
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.profilePath),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
      titleWidget: Text(
        AppStrings.languageAndLocalization,
        style: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _displayLabelLanguageName(String code) {
    return switch (code) {
      'en' => AppStrings.languageEnglish,
      'ar' => AppStrings.languageArabic,
      'ur' => AppStrings.languageUrdu,
      _ => AppStrings.languageEnglish,
    };
  }

  String _displayContentLanguageName(String code) {
    return switch (code) {
      'en-IN' => AppStrings.languageEnglishIndia,
      'ur-IN' => AppStrings.languageUrdu,
      'mr-IN' => AppStrings.languageMarathi,
      _ => AppStrings.languageEnglishIndia,
    };
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: const [AppShadows.ghost],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          child,
        ],
      ),
    );
  }
}
