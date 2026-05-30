import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/core.dart';

/// Reusable legal document page (Privacy Policy, Terms of Service).
///
/// Displays formatted legal content in a scrollable page with the app's
/// standard design system. Required for Google Play Store compliance.
class LegalPage extends StatelessWidget {
  const LegalPage({super.key, required this.title, required this.sections});
  final String title;
  final List<LegalSection> sections;

  /// Shows the Privacy Policy page.
  static Widget privacyPolicy() {
    return Builder(
      builder: (context) {
        return LegalPage(
          title: context.l10n.privacyPolicyTitle,
          sections: [
            LegalSection(
              title: context.l10n.legalInfoWeCollect,
              content: context.l10n.legalInfoWeCollectContent,
            ),
            LegalSection(
              title: context.l10n.legalHowWeUse,
              content: context.l10n.legalHowWeUseContent,
            ),
            LegalSection(
              title: context.l10n.legalDataStorage,
              content: context.l10n.legalDataStorageContent,
            ),
            LegalSection(
              title: context.l10n.legalThirdParty,
              content: context.l10n.legalThirdPartyContent,
            ),
            LegalSection(
              title: context.l10n.legalYourRights,
              content: context.l10n.legalYourRightsContent,
            ),
            LegalSection(
              title: context.l10n.legalChildrenPrivacy,
              content: context.l10n.legalChildrenPrivacyContent,
            ),
            LegalSection(
              title: context.l10n.legalChanges,
              content: context.l10n.legalChangesContent,
            ),
            LegalSection(
              title: context.l10n.legalContact,
              content: context.l10n.legalContactContent,
            ),
          ],
        );
      },
    );
  }

  /// Shows the Terms of Service page.
  static Widget termsOfService() {
    return Builder(
      builder: (context) {
        return LegalPage(
          title: context.l10n.termsOfServiceTitle,
          sections: [
            LegalSection(
              title: context.l10n.legalAcceptance,
              content: context.l10n.legalAcceptanceContent,
            ),
            LegalSection(
              title: context.l10n.legalUseOfService,
              content: context.l10n.legalUseOfServiceContent,
            ),
            LegalSection(
              title: context.l10n.legalUserAccounts,
              content: context.l10n.legalUserAccountsContent,
            ),
            LegalSection(
              title: context.l10n.legalIntellectualProperty,
              content: context.l10n.legalIntellectualPropertyContent,
            ),
            LegalSection(
              title: context.l10n.legalTermination,
              content: context.l10n.legalTerminationContent,
            ),
            LegalSection(
              title: context.l10n.legalDisclaimer,
              content: context.l10n.legalDisclaimerContent,
            ),
            LegalSection(
              title: context.l10n.legalGoverningLaw,
              content: context.l10n.legalGoverningLawContent,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            surfaceTintColor: AppColors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(LucideIcons.arrowLeft),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            ),
            title: Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const LegalEffectiveDateBadge(),
                const SizedBox(height: AppDimensions.paddingXXL),
                ...sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  return LegalSectionCard(index: index + 1, section: section);
                }),
                const SizedBox(height: AppDimensions.paddingXXL),
                const LegalFooter(),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
