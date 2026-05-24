import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';
import 'legal_effective_date_badge.dart';
import 'legal_footer.dart';
import 'legal_section.dart';
import 'legal_section_card.dart';

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
    return const LegalPage(
      title: AppStrings.privacyPolicyTitle,
      sections: [
        LegalSection(
          title: AppStrings.legalInfoWeCollect,
          content: AppStrings.legalInfoWeCollectContent,
        ),
        LegalSection(
          title: AppStrings.legalHowWeUse,
          content: AppStrings.legalHowWeUseContent,
        ),
        LegalSection(
          title: AppStrings.legalDataStorage,
          content: AppStrings.legalDataStorageContent,
        ),
        LegalSection(
          title: AppStrings.legalThirdParty,
          content: AppStrings.legalThirdPartyContent,
        ),
        LegalSection(
          title: AppStrings.legalYourRights,
          content: AppStrings.legalYourRightsContent,
        ),
        LegalSection(
          title: AppStrings.legalChildrenPrivacy,
          content: AppStrings.legalChildrenPrivacyContent,
        ),
        LegalSection(
          title: AppStrings.legalChanges,
          content: AppStrings.legalChangesContent,
        ),
        LegalSection(
          title: AppStrings.legalContact,
          content: AppStrings.legalContactContent,
        ),
      ],
    );
  }

  /// Shows the Terms of Service page.
  static Widget termsOfService() {
    return const LegalPage(
      title: AppStrings.termsOfServiceTitle,
      sections: [
        LegalSection(
          title: AppStrings.legalAcceptance,
          content: AppStrings.legalAcceptanceContent,
        ),
        LegalSection(
          title: AppStrings.legalUseOfService,
          content: AppStrings.legalUseOfServiceContent,
        ),
        LegalSection(
          title: AppStrings.legalUserAccounts,
          content: AppStrings.legalUserAccountsContent,
        ),
        LegalSection(
          title: AppStrings.legalIntellectualProperty,
          content: AppStrings.legalIntellectualPropertyContent,
        ),
        LegalSection(
          title: AppStrings.legalTermination,
          content: AppStrings.legalTerminationContent,
        ),
        LegalSection(
          title: AppStrings.legalDisclaimer,
          content: AppStrings.legalDisclaimerContent,
        ),
        LegalSection(
          title: AppStrings.legalGoverningLaw,
          content: AppStrings.legalGoverningLawContent,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            surfaceTintColor: AppColors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(LucideIcons.arrowLeft),
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


