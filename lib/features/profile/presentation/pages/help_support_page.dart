import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../widgets/support_contact_sheet.dart';

/// Help & Support page – FAQ and contact options.
///
/// Accessible from profile settings. Features expandable FAQ cards,
/// contact options, and app version info.
class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _faqSectionKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingXXL),
                // Hero card
                _buildHeroCard(),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Quick actions
                const AppSectionTitle(title: AppStrings.quickActions),
                const SizedBox(height: AppDimensions.paddingLG),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickAction(
                        context: context,
                        icon: LucideIcons.messageCircle,
                        label: AppStrings.chatWithUs,
                        color: AppColors.primary,
                        bgColor: AppColors.primaryFixed,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMD),
                    Expanded(
                      child: _buildQuickAction(
                        context: context,
                        icon: LucideIcons.mail,
                        label: AppStrings.emailUs,
                        color: AppColors.secondary,
                        bgColor: AppColors.secondaryFixed,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingMD),
                    Expanded(
                      child: _buildQuickAction(
                        context: context,
                        icon: LucideIcons.fileQuestion,
                        label: AppStrings.faqLabel,
                        color: AppColors.tertiary,
                        bgColor: AppColors.tertiaryFixed,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // FAQ section
                Container(
                  key: _faqSectionKey,
                  child: const AppSectionTitle(
                    title: AppStrings.frequentlyAsked,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildFaqCard(
                  question: AppStrings.faq1Question,
                  answer: AppStrings.faq1Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  question: AppStrings.faq2Question,
                  answer: AppStrings.faq2Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  question: AppStrings.faq3Question,
                  answer: AppStrings.faq3Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  question: AppStrings.faq4Question,
                  answer: AppStrings.faq4Answer,
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // Resources section
                const AppSectionTitle(title: AppStrings.resources),
                const SizedBox(height: AppDimensions.paddingLG),
                _buildResourceTile(
                  context: context,
                  icon: LucideIcons.book,
                  title: AppStrings.userGuide,
                  subtitle: AppStrings.userGuideDesc,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildResourceTile(
                  context: context,
                  icon: LucideIcons.video,
                  title: AppStrings.videoTutorials,
                  subtitle: AppStrings.videoTutorialsDesc,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildResourceTile(
                  context: context,
                  icon: LucideIcons.shield,
                  title: AppStrings.privacyPolicyTitle,
                  subtitle: AppStrings.privacyPolicyDesc,
                  onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildResourceTile(
                  context: context,
                  icon: LucideIcons.fileText,
                  title: AppStrings.termsOfServiceTitle,
                  subtitle: AppStrings.termsOfServiceDesc,
                  onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                // App version info
                _buildVersionCard(),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.profilePath),
        icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
      ),
      title: Text(
        AppStrings.helpAndSupport,
        style: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurface),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: const SignatureGlowDecoration(),
      child: Column(
        children: [
          Container(
            width: AppDimensions.avatarHero,
            height: AppDimensions.avatarHero,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.helpCircle,
              size: AppDimensions.iconXXL,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.helpHeroTitle,
            style: AppTextStyles.headlineSmall.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.helpHeroSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.white.withValues(
                alpha: AppDimensions.opacityHigh,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => _handleQuickAction(context, label),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AppCard(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingXL,
            horizontal: AppDimensions.paddingSM,
          ),
          child: Column(
            children: [
              Container(
                width: AppDimensions.avatarLG,
                height: AppDimensions.avatarLG,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppDimensions.iconLG, color: color),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard({required String question, required String answer}) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: ThemeData(dividerColor: AppColors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingXS,
          ),
          childrenPadding: const EdgeInsets.only(
            left: AppDimensions.paddingXL,
            right: AppDimensions.paddingXL,
            bottom: AppDimensions.paddingLG,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: AppDimensions.avatarSM,
            height: AppDimensions.avatarSM,
            decoration: const BoxDecoration(
              color: AppColors.primaryFixed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.helpCircle,
              size: AppDimensions.iconSM,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            question,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          children: [
            Text(
              answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap ?? () => _handleResourceTap(context, title),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXL,
            vertical: AppDimensions.paddingLG,
          ),
          child: Row(
            children: [
              AppIconCircle(
                icon: icon,
                backgroundColor: AppColors.surfaceContainerHigh,
                iconColor: AppColors.outline,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: AppDimensions.iconMD,
                color: AppColors.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Column(
        children: [
          const Icon(
            LucideIcons.sparkles,
            size: AppDimensions.iconLG,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.appName,
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            AppStrings.appVersion,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            AppStrings.madeWithLove,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.outline),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(BuildContext context, String label) {
    if (label == AppStrings.faqLabel) {
      _scrollToFaq();
      return;
    }

    final subtitle = label == AppStrings.chatWithUs
        ? 'Get help from the support team with common account and learning issues.'
        : 'Copy the support email so you can reach us directly from your inbox.';

    SupportContactSheet.show(
      context,
      title: label,
      subtitle: subtitle,
      email: 'support@formulascholar.app',
    );
  }

  void _handleResourceTap(BuildContext context, String title) {
    if (title == AppStrings.userGuide || title == AppStrings.videoTutorials) {
      SupportContactSheet.show(
        context,
        title: title,
        subtitle:
            'These learning resources are curated from the live app flow. '
            'Use the FAQ and contact sheet while the richer resource library is being expanded.',
        email: 'support@formulascholar.app',
      );
      return;
    }

    SupportContactSheet.show(
      context,
      title: title,
      subtitle:
          'This resource is being expanded. Contact support for immediate guidance and access help.',
      email: 'support@formulascholar.app',
    );
  }

  void _scrollToFaq() {
    final targetContext = _faqSectionKey.currentContext;
    if (targetContext == null) return;

    Scrollable.ensureVisible(
      targetContext,
      duration: AppDurations.animationDefault,
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }
}
