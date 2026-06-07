library;

import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

/// Fullscreen carousel page for rapid formula revision.
class VaultQuickRevisionPage extends StatefulWidget {
  const VaultQuickRevisionPage({
    required this.formulas,
    super.key,
  });

  final List<BookmarkedFormula> formulas;

  @override
  State<VaultQuickRevisionPage> createState() => _VaultQuickRevisionPageState();
}

class _VaultQuickRevisionPageState extends State<VaultQuickRevisionPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FabVisibilityManager.fabOffset.value = 80.0;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FabVisibilityManager.fabOffset.value = 0.0;
    });
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = widget.formulas.length;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
        ),
        title: Text(
          context.l10n.quickRevisionTitle,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: AppDimensions.paddingLG,
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                  vertical: AppDimensions.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                ),
                child: Text(
                  context.l10n.quickRevisionProgress(
                    _currentPage + 1,
                    total,
                  ),
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXXL,
            ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusXS),
                        child: LinearProgressIndicator(
                          value: total > 0 ? (_currentPage + 1) / total : 0,
                          minHeight: 4,
                          backgroundColor: colorScheme.surfaceContainerHigh,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    // Formula cards
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: total,
                        onPageChanged: (index) {
                          setState(() => _currentPage = index);
                        },
                        itemBuilder: (context, index) {
                          final formula = widget.formulas[index];
                          return _RevisionCard(
                            formula: formula,
                            isDark: isDark,
                          );
                        },
                      ),
                    ),
                    // Navigation controls
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _NavButton(
                              icon: LucideIcons.chevronLeft,
                              enabled: _currentPage > 0,
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: AppDurations.animationDefault,
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                            // Dot indicators (max 10 visible)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                total.clamp(0, 10),
                                (i) {
                                  final dotIndex = total <= 10
                                      ? i
                                      : (_currentPage - 4).clamp(0, total - 10) + i;
                                  return AnimatedContainer(
                                    duration: AppDurations.animationFast,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    width: dotIndex == _currentPage ? 24 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: dotIndex == _currentPage
                                          ? colorScheme.primary
                                          : colorScheme.outlineVariant,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  );
                                },
                              ),
                            ),
                            _NavButton(
                              icon: LucideIcons.chevronRight,
                              enabled: _currentPage < total - 1,
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: AppDurations.animationDefault,
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
      ),
    );
  }
}

class _RevisionCard extends StatelessWidget {
  const _RevisionCard({
    required this.formula,
    required this.isDark,
  });

  final BookmarkedFormula formula;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingSectionLG),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Subject badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLG,
                  vertical: AppDimensions.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                ),
                child: Text(
                  formula.subject.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              // Title
              Text(
                formula.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingSectionLG),
              // LaTeX formula
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingXXL),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Math.tex(
                      formula.formula,
                      textStyle: AppTextStyles.headlineMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return IconButton.filledTonal(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: enabled
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerHigh,
        foregroundColor: enabled
            ? colorScheme.onPrimaryContainer
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
      ),
    );
  }
}
