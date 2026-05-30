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
    final colorScheme = Theme.of(context).colorScheme;

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
                        title: l10n.languageAndLocalization,
                        subtitle:
                            'Choose your preferred language for the app interface and content.',
                        child: DropdownButtonFormField<String>(
                          initialValue: state
                              .effectiveAppLocale(systemLocale)
                              .languageCode,
                          decoration: const InputDecoration(
                            labelText: 'Global Language',
                            prefixIcon: Icon(
                              Icons.language,
                              size: AppDimensions.iconMD,
                            ),
                          ),
                          items: AppLocales.appLabelSupportedLocales.map((
                            locale,
                          ) {
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
                                      _languageAbbreviation(
                                        locale.languageCode,
                                      ),
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: colorScheme.onSecondaryContainer,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppDimensions.paddingMD,
                                  ),
                                  Text(
                                    _displayLabelLanguageName(
                                      context,
                                      locale.languageCode,
                                    ),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    EntranceWrapper.stagger(
                      index: 1,
                      child: ExpansionTile(
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
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLG,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLG,
                          ),
                        ),
                        backgroundColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        collapsedBackgroundColor: colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.1),
                        childrenPadding: const EdgeInsets.all(
                          AppDimensions.paddingLG,
                        ),
                        children: [
                          _SectionCard(
                            title: l10n.labelsLocalizationTitle,
                            subtitle: l10n.labelsLocalizationSubtitle,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile.adaptive(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    l10n.enableLabelsLocalization,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    l10n.enableLabelsLocalizationDesc,
                                  ),
                                  value: state.appLabelLocalizationEnabled,
                                  onChanged: (v) => context
                                      .read<LocalizationCubit>()
                                      .setAppLabelLocalizationEnabled(v),
                                ),
                                const SizedBox(height: AppDimensions.paddingSM),
                                SwitchListTile.adaptive(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    l10n.useSystemLanguage,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                                const SizedBox(height: AppDimensions.paddingLG),
                                DropdownButtonFormField<String>(
                                  initialValue: state.appLabelLanguageCode,
                                  decoration: InputDecoration(
                                    labelText: l10n.appLabelLanguage,
                                    prefixIcon: const Icon(
                                      Icons.translate,
                                      size: AppDimensions.iconMD,
                                    ),
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
                                                  color: colorScheme
                                                      .secondaryContainer,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _languageAbbreviation(
                                                    locale.languageCode,
                                                  ),
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                        color: colorScheme
                                                            .onSecondaryContainer,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: AppDimensions.paddingMD,
                                              ),
                                              Text(
                                                _displayLabelLanguageName(
                                                  context,
                                                  locale.languageCode,
                                                ),
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
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
                          const SizedBox(height: AppDimensions.paddingXL),
                          _SectionCard(
                            title: l10n.contentLocalizationTitle,
                            subtitle: l10n.contentLocalizationSubtitle,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile.adaptive(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    l10n.enableContentLocalization,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  subtitle: Text(
                                    l10n.enableContentLocalizationDesc,
                                  ),
                                  value: state.contentLocalizationEnabled,
                                  onChanged: (v) => context
                                      .read<LocalizationCubit>()
                                      .setContentLocalizationEnabled(v),
                                ),
                                const SizedBox(height: AppDimensions.paddingLG),
                                DropdownButtonFormField<String>(
                                  initialValue:
                                      AppLocales.normalizeContentLocaleCode(
                                        state.contentLocaleCode,
                                      ),
                                  decoration: InputDecoration(
                                    labelText: l10n.contentLanguage,
                                    prefixIcon: const Icon(
                                      LucideIcons.globe,
                                      size: AppDimensions.iconMD,
                                    ),
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
                                                  color: colorScheme
                                                      .secondaryContainer,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _languageAbbreviation(code),
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                        color: colorScheme
                                                            .onSecondaryContainer,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: AppDimensions.paddingMD,
                                              ),
                                              Text(
                                                _displayContentLanguageName(
                                                  context,
                                                  code,
                                                ),
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
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
                                          context
                                              .read<LocalizationCubit>()
                                              .setContentLocaleCode(code);
                                        },
                                ),
                                const SizedBox(height: AppDimensions.paddingLG),
                                Container(
                                  padding: const EdgeInsets.all(
                                    AppDimensions.paddingMD,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHigh
                                        .withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusMD,
                                    ),
                                    border: Border.all(
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        LucideIcons.info,
                                        size: AppDimensions.iconSM,
                                        color: colorScheme.outline,
                                      ),
                                      const SizedBox(
                                        width: AppDimensions.paddingSM,
                                      ),
                                      Expanded(
                                        child: Text(
                                          l10n.contentLocalizationFallbackInfo,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
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
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXL),
                    EntranceWrapper.stagger(
                      index: 2,
                      child: AppGlassCard(
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
                              symbol: _languageAbbreviation(
                                state
                                    .effectiveAppLocale(systemLocale)
                                    .languageCode,
                              ),
                              value: _displayLabelLanguageName(
                                context,
                                state
                                    .effectiveAppLocale(systemLocale)
                                    .languageCode,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingMD),
                            _SummaryRow(
                              icon: LucideIcons.globe,
                              label: l10n.backendContent,
                              symbol: _languageAbbreviation(
                                state.effectiveContentLocaleCode,
                              ),
                              value: _displayContentLanguageName(
                                context,
                                state.effectiveContentLocaleCode,
                              ),
                            ),
                          ],
                        ),
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
      'mr' => l10n.languageMarathi,
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

  String _languageAbbreviation(String code) {
    if (code.isEmpty) return '';
    return code.split('-').first.toUpperCase();
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
    return AppGlassCard(
      borderRadius: AppDimensions.radiusLG,
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
          if (child is! SizedBox) ...[
            const SizedBox(height: AppDimensions.paddingXL),
            child,
          ],
        ],
      ),
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
