import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

class LanguageLocalizationPage extends StatelessWidget {
  const LanguageLocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                        title: l10n.labelsLocalizationTitle,
                        subtitle: l10n.labelsLocalizationSubtitle,
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.enableLabelsLocalization),
                              subtitle: Text(l10n.enableLabelsLocalizationDesc),
                              value: state.appLabelLocalizationEnabled,
                              onChanged: (v) => context
                                  .read<LocalizationCubit>()
                                  .setAppLabelLocalizationEnabled(v),
                            ),
                            const SizedBox(height: AppDimensions.paddingSM),
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.useSystemLanguage),
                              subtitle: Text(
                                '${l10n.currentSystemLanguage}: ${_displayLabelLanguageName(context, systemLocale.languageCode)}',
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
                              decoration: InputDecoration(
                                labelText: l10n.appLabelLanguage,
                                border: const OutlineInputBorder(),
                              ),
                              items: AppLocales.appLabelSupportedLocales
                                  .map(
                                    (locale) => DropdownMenuItem<String>(
                                      value: locale.languageCode,
                                      child: Text(
                                        _displayLabelLanguageName(
                                          context,
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
                        title: l10n.contentLocalizationTitle,
                        subtitle: l10n.contentLocalizationSubtitle,
                        child: Column(
                          children: [
                            SwitchListTile.adaptive(
                              contentPadding: EdgeInsets.zero,
                              title: Text(l10n.enableContentLocalization),
                              subtitle: Text(
                                l10n.enableContentLocalizationDesc,
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
                              decoration: InputDecoration(
                                labelText: l10n.contentLanguage,
                                border: const OutlineInputBorder(),
                              ),
                              items: AppLocales.contentSupportedLocaleCodes
                                  .map(
                                    (code) => DropdownMenuItem<String>(
                                      value: code,
                                      child: Text(
                                        _displayContentLanguageName(
                                          context,
                                          code,
                                        ),
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
                              l10n.contentLocalizationFallbackInfo,
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
                        title: l10n.localizationEffectiveSummary,
                        subtitle:
                            '${l10n.appLabels}: ${_displayLabelLanguageName(context, state.effectiveAppLocale(systemLocale).languageCode)}\n${l10n.backendContent}: ${_displayContentLanguageName(context, state.effectiveContentLocaleCode)}',
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
    final l10n = context.l10n;
    return SliverGlassAppBar(
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.profilePath),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      ),
      titleWidget: Text(
        l10n.languageAndLocalization,
        style: AppTextStyles.titleMedium.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _displayLabelLanguageName(BuildContext context, String code) {
    final l10n = context.l10n;
    return switch (code) {
      'en' => l10n.languageEnglish,
      'ar' => l10n.languageArabic,
      'ur' => l10n.languageUrdu,
      _ => l10n.languageEnglish,
    };
  }

  String _displayContentLanguageName(BuildContext context, String code) {
    final l10n = context.l10n;
    final localName = switch (code) {
      'ar-IN' => l10n.languageArabic,
      'en-IN' => l10n.languageEnglishIndia,
      'ur-IN' => l10n.languageUrdu,
      'mr-IN' => l10n.languageMarathi,
      _ => null,
    };
    if (localName != null) {
      return localName;
    }
    for (final loc in AppLocales.contentSupportedLocales) {
      if (loc.code == code) {
        return loc.name;
      }
    }
    return code;
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
