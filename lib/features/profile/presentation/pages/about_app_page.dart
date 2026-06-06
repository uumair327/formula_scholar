import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: context.l10n.appName,
      applicationVersion:
          '1.0.0', // Should ideally come from package_info_plus, but 1.0.0 is fine for now
      applicationIcon: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Icon(
          LucideIcons.sparkles,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      applicationLegalese: '© ${DateTime.now().year} Formula Scholar Team',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverGlassAppBar(
            title: context.l10n.aboutAppTitle,
            automaticallyImplyLeading: true,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.value(
                context: context,
                mobile: AppDimensions.paddingXL,
                desktop:
                    AppDimensions.paddingSectionLG * 2 +
                    AppDimensions.paddingXL,
              ),
              vertical: AppDimensions.paddingXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header (App Branding)
                EntranceWrapper.stagger(
                  index: 0,
                  child: Center(
                    child: Column(
                      children: [
                        AppIconCircle(
                          icon: LucideIcons.sparkles,
                          size: 80,
                          backgroundColor: colorScheme.primaryContainer,
                          iconColor: colorScheme.primary,
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                        Text(
                          context.l10n.appName,
                          style: AppTextStyles.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXS),
                        Text(
                          context.l10n.aboutAppTagline,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.paddingMD),
                        AppInfoChip(
                          label: '${context.l10n.appVersion} 1.0.0 (Beta)',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Developer Section
                EntranceWrapper.stagger(
                  index: 1,
                  child: AppSectionTitle(
                    title: context.l10n.aboutDeveloperSection,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(
                  index: 2,
                  child: AppGlassCard(
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        AppIconCircle(
                          icon: LucideIcons.code,
                          size: 48,
                          backgroundColor: colorScheme.secondaryContainer,
                          iconColor: colorScheme.secondary,
                        ),
                        const SizedBox(width: AppDimensions.paddingLG),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.aboutDeveloperName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingXXS),
                              GestureDetector(
                                onTap: () => _launchUrl(
                                  'mailto:${context.l10n.aboutDeveloperEmail}',
                                ),
                                child: Text(
                                  context.l10n.aboutDeveloperEmail,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Legal Section
                EntranceWrapper.stagger(
                  index: 3,
                  child: AppSectionTitle(title: context.l10n.aboutLegalSection),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(
                  index: 4,
                  child: AppCard(
                    onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        Icon(LucideIcons.shield, color: colorScheme.primary),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.privacyPolicyTitle,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context.l10n.aboutPrivacyDesc,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 5,
                  child: AppCard(
                    onTap: () =>
                        context.pushNamed(AppRoutes.termsOfServiceName),
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        Icon(LucideIcons.fileText, color: colorScheme.primary),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.termsOfServiceTitle,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context.l10n.aboutTermsDesc,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 6,
                  child: AppCard(
                    onTap: () => _showLicenses(context),
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        Icon(LucideIcons.bookOpen, color: colorScheme.primary),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.aboutOpenSourceLicenses,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context.l10n.aboutOpenSourceDesc,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Share & Rate
                EntranceWrapper.stagger(
                  index: 7,
                  child: AppCard(
                    onTap: () {
                      // Placeholder for actual sharing functionality
                      ComingSoonSheet.show(
                        context,
                        featureName: context.l10n.aboutShareApp,
                      );
                    },
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        Icon(Icons.share, color: colorScheme.secondary),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.aboutShareApp,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context.l10n.aboutShareDesc,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 8,
                  child: AppCard(
                    onTap: () {
                      // Placeholder for actual rating functionality
                      ComingSoonSheet.show(
                        context,
                        featureName: context.l10n.aboutRateApp,
                      );
                    },
                    padding: const EdgeInsets.all(AppDimensions.paddingLG),
                    child: Row(
                      children: [
                        Icon(LucideIcons.star, color: colorScheme.tertiary),
                        const SizedBox(width: AppDimensions.paddingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.aboutRateApp,
                                style: AppTextStyles.titleSmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                context.l10n.aboutRateDesc,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Footer
                EntranceWrapper.stagger(
                  index: 9,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          context.l10n.madeWithLove,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          '© ${DateTime.now().year} ${context.l10n.aboutDeveloperName}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(178),
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
  }
}
