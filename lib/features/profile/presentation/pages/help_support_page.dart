import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
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
                desktop: AppDimensions.paddingSectionLG * 2 + AppDimensions.paddingXL,
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(index: 0, child: const HelpHeroCard()),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(index: 1, child: const AppSectionTitle(title: AppStrings.quickActions)),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(index: 2, child: HelpQuickActions(onFaqTap: _scrollToFaq)),
                const SizedBox(height: AppDimensions.paddingXXL),
                Container(
                  key: _faqSectionKey,
                  child: EntranceWrapper.stagger(
                    index: 3,
                    child: const AppSectionTitle(title: AppStrings.frequentlyAsked),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(index: 4, child: const HelpFaqCard(question: AppStrings.faq1Question, answer: AppStrings.faq1Answer)),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 5, child: const HelpFaqCard(question: AppStrings.faq2Question, answer: AppStrings.faq2Answer)),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 6, child: const HelpFaqCard(question: AppStrings.faq3Question, answer: AppStrings.faq3Answer)),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 7, child: const HelpFaqCard(question: AppStrings.faq4Question, answer: AppStrings.faq4Answer)),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(index: 8, child: const AppSectionTitle(title: AppStrings.resources)),
                const SizedBox(height: AppDimensions.paddingLG),
                EntranceWrapper.stagger(index: 9, child: HelpResourceTile(
                  icon: LucideIcons.book, title: AppStrings.userGuide, subtitle: AppStrings.userGuideDesc,
                  onTap: () => _handleResourceTap(context, AppStrings.userGuide),
                )),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 10, child: HelpResourceTile(
                  icon: LucideIcons.video, title: AppStrings.videoTutorials, subtitle: AppStrings.videoTutorialsDesc,
                  onTap: () => _handleResourceTap(context, AppStrings.videoTutorials),
                )),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 11, child: HelpResourceTile(
                  icon: LucideIcons.shield, title: AppStrings.privacyPolicyTitle, subtitle: AppStrings.privacyPolicyDesc,
                  onTap: () => context.pushNamed(AppRoutes.privacyPolicyName),
                )),
                const SizedBox(height: AppDimensions.paddingMD),
                EntranceWrapper.stagger(index: 12, child: HelpResourceTile(
                  icon: LucideIcons.fileText, title: AppStrings.termsOfServiceTitle, subtitle: AppStrings.termsOfServiceDesc,
                  onTap: () => context.pushNamed(AppRoutes.termsOfServiceName),
                )),
                const SizedBox(height: AppDimensions.paddingXXL),
                EntranceWrapper.stagger(index: 13, child: const HelpVersionCard()),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
