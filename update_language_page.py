import codecs

filepath = r"c:\Users\uumai\Downloads\zip\formula_scholar\lib\features\profile\presentation\pages\language_localization_page.dart"

with codecs.open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# We need to replace the CustomScrollView slivers body to include the unified language selector.
# We'll find the start of the SliverList delegate: SliverChildListDelegate([
# and then replace everything up to the end of the SliverList.

start_marker = "delegate: SliverChildListDelegate(["
end_marker = "]),\n                ),\n              ),"

start_idx = content.find(start_marker)
end_idx = content.find(end_marker, start_idx)

if start_idx == -1 or end_idx == -1:
    print("Could not find markers.")
    exit(1)

new_slivers = """delegate: SliverChildListDelegate([
                    const SizedBox(height: AppDimensions.paddingXXL),
                    EntranceWrapper.stagger(
                      index: 0,
                      child: _SectionCard(
                        title: l10n.languageAndLocalization,
                        subtitle: "Choose your preferred language for the app interface and content.",
                        child: DropdownButtonFormField<String>(
                          value: state.effectiveAppLocale(systemLocale).languageCode,
                          decoration: InputDecoration(
                            labelText: "Global Language",
                            prefixIcon: const Icon(
                              Icons.language,
                              size: AppDimensions.iconMD,
                            ),
                          ),
                          items: AppLocales.appLabelSupportedLocales.map((locale) {
                            return DropdownMenuItem<String>(
                              value: locale.languageCode,
                              child: Row(
                                children: [
                                  Text(
                                    _labelLanguageFlag(locale.languageCode),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: AppDimensions.paddingMD),
                                  Text(
                                    _displayLabelLanguageName(context, locale.languageCode),
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
                              _ => '${code}-IN', // Fallback
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
                          "Advanced Translation Customization",
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          "Granular controls for app labels and content",
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
                                  subtitle: Text('${l10n.currentSystemLanguage}: ${_displayLabelLanguageName(context, systemLocale.languageCode)}'),
                                  value: state.useSystemAppLabelLocale && isAppLabelControlsEnabled,
                                  onChanged: isAppLabelControlsEnabled
                                      ? (v) => context.read<LocalizationCubit>().setUseSystemAppLabelLocale(v)
                                      : null,
                                ),
                                const SizedBox(height: AppDimensions.paddingLG),
                                DropdownButtonFormField<String>(
                                  value: state.appLabelLanguageCode,
                                  decoration: InputDecoration(
                                    labelText: l10n.appLabelLanguage,
                                    prefixIcon: const Icon(Icons.translate, size: AppDimensions.iconMD),
                                  ),
                                  items: AppLocales.appLabelSupportedLocales.map((locale) => DropdownMenuItem<String>(
                                    value: locale.languageCode,
                                    child: Row(
                                      children: [
                                        Text(_labelLanguageFlag(locale.languageCode), style: const TextStyle(fontSize: 18)),
                                        const SizedBox(width: AppDimensions.paddingMD),
                                        Text(_displayLabelLanguageName(context, locale.languageCode), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  )).toList(),
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
                                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(l10n.enableContentLocalizationDesc),
                                  value: state.contentLocalizationEnabled,
                                  onChanged: (v) => context.read<LocalizationCubit>().setContentLocalizationEnabled(v),
                                ),
                                const SizedBox(height: AppDimensions.paddingLG),
                                DropdownButtonFormField<String>(
                                  value: AppLocales.normalizeContentLocaleCode(state.contentLocaleCode),
                                  decoration: InputDecoration(
                                    labelText: l10n.contentLanguage,
                                    prefixIcon: const Icon(LucideIcons.globe, size: AppDimensions.iconMD),
                                  ),
                                  items: AppLocales.contentSupportedLocaleCodes.map((code) => DropdownMenuItem<String>(
                                    value: code,
                                    child: Row(
                                      children: [
                                        Text(_contentLanguageFlag(code), style: const TextStyle(fontSize: 18)),
                                        const SizedBox(width: AppDimensions.paddingMD),
                                        Text(_displayContentLanguageName(context, code), style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  )).toList(),
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
                              flag: _labelLanguageFlag(state.effectiveAppLocale(systemLocale).languageCode),
                              value: _displayLabelLanguageName(context, state.effectiveAppLocale(systemLocale).languageCode),
                            ),
                            const SizedBox(height: AppDimensions.paddingMD),
                            _SummaryRow(
                              icon: LucideIcons.globe,
                              label: l10n.backendContent,
                              flag: _contentLanguageFlag(state.effectiveContentLocaleCode),
                              value: _displayContentLanguageName(context, state.effectiveContentLocaleCode),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.bottomNavPadding),
"""

new_content = content[:start_idx] + new_slivers + content[end_idx:]

# In the DropdownButtonFormField, initialValue causes errors if we also provide value or if it rebuilds.
# We need to change `initialValue:` to `value:` in the original code snippet which we replaced anyway!
# Oh, wait! The original code had `initialValue:`! We need to make sure we use `value:` instead, which I did in the python snippet above.

with codecs.open(filepath, 'w', encoding='utf-8') as f:
    f.write(new_content)

print("Updated successfully.")
