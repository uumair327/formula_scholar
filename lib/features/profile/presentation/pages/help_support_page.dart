import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../widgets/help/help_app_bar.dart';
import '../widgets/help/help_faq_card.dart';
import '../widgets/help/help_hero_card.dart';
import '../widgets/help/help_quick_actions.dart';
import '../widgets/help/help_resource_tile.dart';
import '../widgets/help/help_version_card.dart';

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

  void _handleResourceTap(BuildContext context, String title) {
    ComingSoonSheet.show(context, featureName: title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const HelpAppBar(),
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
                EntranceWrapper.stagger(index: 0, child: const HelpHeroCard()),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(
                  index: 1,
                  child: AppSectionTitle(title: context.l10n.quickActions),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(
                  index: 2,
                  child: HelpQuickActions(onFaqTap: _scrollToFaq),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                Container(
                  key: _faqSectionKey,
                  child: EntranceWrapper.stagger(
                    index: 3,
                    child: AppSectionTitle(title: context.l10n.frequentlyAsked),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(
                  index: 4,
                  child: HelpFaqCard(
                    question: context.l10n.faq1Question,
                    answer: context.l10n.faq1Answer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 5,
                  child: HelpFaqCard(
                    question: context.l10n.faq2Question,
                    answer: context.l10n.faq2Answer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 6,
                  child: HelpFaqCard(
                    question: context.l10n.faq3Question,
                    answer: context.l10n.faq3Answer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 7,
                  child: HelpFaqCard(
                    question: context.l10n.faq4Question,
                    answer: context.l10n.faq4Answer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(
                  index: 8,
                  child: AppSectionTitle(title: context.l10n.resources),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(
                  index: 9,
                  child: HelpResourceTile(
                    icon: LucideIcons.book,
                    title: context.l10n.userGuide,
                    subtitle: context.l10n.userGuideDesc,
                    onTap: () =>
                        _handleResourceTap(context, context.l10n.userGuide),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 10,
                  child: HelpResourceTile(
                    icon: LucideIcons.video,
                    title: context.l10n.videoTutorials,
                    subtitle: context.l10n.videoTutorialsDesc,
                    onTap: () => _handleResourceTap(
                      context,
                      context.l10n.videoTutorials,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 11,
                  child: HelpResourceTile(
                    icon: LucideIcons.shield,
                    title: context.l10n.privacyPolicyTitle,
                    subtitle: context.l10n.privacyPolicyDesc,
                    onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(
                  index: 12,
                  child: HelpResourceTile(
                    icon: LucideIcons.fileText,
                    title: context.l10n.termsOfServiceTitle,
                    subtitle: context.l10n.termsOfServiceDesc,
                    onTap: () =>
                        context.pushNamed(AppRoutes.termsOfServiceName),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(
                  index: 13,
                  child: const HelpVersionCard(),
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
