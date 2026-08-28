import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../widgets/localization/global_language_selector.dart';
import '../widgets/localization/advanced_translation_controls.dart';
import '../widgets/localization/localization_summary_card.dart';

class LanguageLocalizationPage extends StatelessWidget {
  const LanguageLocalizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
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
                EntranceWrapper.stagger(
                  index: 0,
                  child: GlobalLanguageSelector(),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                EntranceWrapper.stagger(
                  index: 1,
                  child: AdvancedTranslationControls(),
                ),
                const SizedBox(height: AppDimensions.paddingXL),
                EntranceWrapper.stagger(
                  index: 2,
                  child: LocalizationSummaryCard(),
                ),
                const SizedBox(height: AppDimensions.bottomNavPadding),
              ]),
            ),
          ),
        ],
      ),
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
}

