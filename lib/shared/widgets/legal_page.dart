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
                // Effective date badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLG,
                    vertical: AppDimensions.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                  ),
                  child: Text(
                    AppStrings.legalEffectiveDate,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),

                // Sections
                ...sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  return _LegalSectionCard(index: index + 1, section: section);
                }),

                const SizedBox(height: AppDimensions.paddingXXL),

                // Footer
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        LucideIcons.shieldCheck,
                        size: AppDimensions.iconXXL,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                      Text(
                        AppStrings.legalFooterTitle,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.paddingSM),
                      Text(
                        AppStrings.legalFooterDesc,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

/// A section within a legal document.
class LegalSection {
  const LegalSection({required this.title, required this.content});
  final String title;
  final String content;
}

class _LegalSectionCard extends StatelessWidget {
  const _LegalSectionCard({required this.index, required this.section});
  final int index;
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: AppDimensions.avatarSM,
                height: AppDimensions.avatarSM,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Expanded(
                child: Text(
                  section.title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.avatarSM + AppDimensions.paddingMD,
            ),
            child: Text(
              section.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
