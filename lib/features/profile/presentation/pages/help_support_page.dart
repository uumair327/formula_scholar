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
                _buildHeroCard(context),
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
                  context,
                  question: AppStrings.faq1Question,
                  answer: AppStrings.faq1Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  context,
                  question: AppStrings.faq2Question,
                  answer: AppStrings.faq2Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  context,
                  question: AppStrings.faq3Question,
                  answer: AppStrings.faq3Answer,
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildFaqCard(
                  context,
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
                  onTap: () => ComingSoonSheet.show(context, featureName: AppStrings.userGuide),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                _buildResourceTile(
                  context: context,
                  icon: LucideIcons.video,
                  title: AppStrings.videoTutorials,
                  subtitle: AppStrings.videoTutorialsDesc,
                  onTap: () => ComingSoonSheet.show(context, featureName: AppStrings.videoTutorials),
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
                _buildVersionCard(context),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: colorScheme.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      leading: IconButton(
        onPressed: () => context.go(AppRoutes.profilePath),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
      ),
      title: Text(
        AppStrings.helpAndSupport,
        style: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: const SignatureGlowDecoration(),
      child: Column(
        children: [
          Container(
            width: AppDimensions.avatarHero,
            height: AppDimensions.avatarHero,
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(
                alpha: AppDimensions.opacitySubtle,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.helpCircle,
              size: AppDimensions.iconXXL,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text(
            AppStrings.helpHeroTitle,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.helpHeroSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onPrimary.withValues(
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqCard(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

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
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.helpCircle,
              size: AppDimensions.iconSM,
              color: colorScheme.primary,
            ),
          ),
          title: Text(
            question,
            style: AppTextStyles.labelLarge.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          children: [
            Text(
              answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
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
    final colorScheme = Theme.of(context).colorScheme;

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
                backgroundColor: colorScheme.surfaceContainerHigh,
                iconColor: colorScheme.outline,
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
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: AppDimensions.iconMD,
                color: colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVersionCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: Column(
        children: [
          Icon(
            LucideIcons.sparkles,
            size: AppDimensions.iconLG,
            color: colorScheme.primary,
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.appName,
            style: AppTextStyles.labelLarge.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            AppStrings.appVersion,
            style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline),
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            AppStrings.madeWithLove,
            style: AppTextStyles.bodySmall.copyWith(color: colorScheme.outline),
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

    if (label == AppStrings.chatWithUs) {
      ComingSoonSheet.show(context, featureName: AppStrings.chatWithUs);
      return;
    }

    final subtitle = label == AppStrings.emailUs
        ? 'Copy the support email so you can reach us directly from your inbox.'
        : '';

    SupportContactSheet.show(
      context,
      title: label,
      subtitle: subtitle,
      email: 'support@formulascholar.app',
    );
  }

  void _handleResourceTap(BuildContext context, String title) {
    ComingSoonSheet.show(context, featureName: title);
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
