import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../../../flashcards/flashcards.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../widgets/formula_note_sheet.dart';
import '../../../widget_viewer/widget_viewer.dart';


/// Formulas page — displays all formulas for a given chapter.
///
/// Renders a list of formula cards with LaTeX expressions,
/// mastery status, and progress tracking.
class FormulasPage extends StatelessWidget {
  const FormulasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormulasCubit, FormulasState>(
      buildWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.formulas != curr.formulas ||
          prev.isChapterSaved != curr.isChapterSaved,
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        if (state.status == FormulasStatus.loading ||
            state.status == FormulasStatus.initial) {
          return const Scaffold(body: FormulasShimmer());
        }

        if (state.status == FormulasStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () {
                if (state.subjectId != null && state.chapterId != null) {
                  final curriculumKey = context
                      .read<CurriculumCubit>()
                      .state
                      .curriculum
                      ?.curriculumKey;
                  context.read<FormulasCubit>().loadFormulas(
                    subjectId: state.subjectId!,
                    chapterId: state.chapterId!,
                    chapterName: state.chapterName,
                    curriculumKey: curriculumKey,
                  );
                }
              },
            ),
          );
        }

        return Scaffold(
          backgroundColor: colorScheme.surfaceContainerLowest,
          body: RefreshIndicator(
            onRefresh: () async {
              if (state.subjectId != null && state.chapterId != null) {
                final curriculumKey = context
                    .read<CurriculumCubit>()
                    .state
                    .curriculum
                    ?.curriculumKey;
                await context.read<FormulasCubit>().loadFormulas(
                  subjectId: state.subjectId!,
                  chapterId: state.chapterId!,
                  chapterName: state.chapterName,
                  curriculumKey: curriculumKey,
                );
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= AppDimensions.breakpointDesktop;
                final hp = isDesktop
                    ? ((constraints.maxWidth - AppDimensions.breakpointMaxContent) / 2).clamp(
                        AppDimensions.paddingSectionLG, double.infinity,
                      )
                    : AppDimensions.paddingLG;
                return CustomScrollView(
                  slivers: [
                    _buildAppBar(context, state),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: AppDimensions.paddingMD),
                          if (state.formulas.isEmpty)
                            _buildEmptyFormulasState(context)
                          else
                            ...state.formulas.asMap().entries.map(
                              (entry) => _StaggeredFadeSlide(
                                index: entry.key,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppDimensions.paddingMD,
                                  ),
                                  child: _StudyCard(
                                    formula: entry.value,
                                    index: entry.key,
                                    totalCount: state.formulas.length,
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: AppDimensions.bottomNavPadding),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyFormulasState(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingXXL),
      child: AppEmptyState(
        icon: LucideIcons.fileQuestion,
        title: 'No formulas available yet',
        description: 'Content for this chapter is being prepared. Check back later!',
      ),
    );
  }

  // ──────────────────────── App Bar ─────────────────────────────

  Widget _buildAppBar(BuildContext context, FormulasState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverGlassAppBar(
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(LucideIcons.arrowLeft, color: colorScheme.onSurface),
      ),
      titleWidget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.chapterName ?? AppStrings.formulasTitle,
            style: AppTextStyles.titleLarge.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.paddingXXS),
          // Compact progress indicator in subtitle
          Row(
            children: [
              Icon(
                state.masteredCount == state.totalCount && state.totalCount > 0
                    ? LucideIcons.checkCircle2
                    : LucideIcons.graduationCap,
                size: AppDimensions.iconXS,
                color: state.masteredCount == state.totalCount && state.totalCount > 0
                    ? AppColors.secondary
                    : colorScheme.outline,
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Text(
                state.totalCount > 0
                    ? '${state.masteredCount} of ${state.totalCount} mastered'
                    : 'No formulas',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (state.totalCount > 0) ...[
                const SizedBox(width: AppDimensions.paddingSM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingSM,
                    vertical: AppDimensions.paddingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: state.progressPercent == 100
                        ? AppColors.secondaryFixed
                        : colorScheme.primaryFixed,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: Text(
                    '${state.progressPercent.toInt()}%',
                    style: AppTextStyles.overline.copyWith(
                      color: state.progressPercent == 100
                          ? AppColors.secondary
                          : colorScheme.primary,
                      fontSize: AppDimensions.fontSizeXS,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      actions: [
        BlocBuilder<FormulasCubit, FormulasState>(
          buildWhen: (prev, curr) => prev.isChapterSaved != curr.isChapterSaved,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                final subjectName =
                    context.read<SubjectSelectionCubit>().state.subject?.name ??
                    AppStrings.unknownSubject;
                final curriculumKey = context
                    .read<CurriculumCubit>()
                    .state
                    .curriculum
                    ?.curriculumKey;

                if (curriculumKey == null || curriculumKey.isEmpty) {
                  return;
                }

                context.read<FormulasCubit>().toggleChapterBookmark(
                  state.chapterName ?? AppStrings.chapterLabel,
                  subjectName,
                  curriculumKey: curriculumKey,
                );
              },
              icon: Icon(
                state.isChapterSaved
                    ? Icons.bookmark
                    : LucideIcons.bookmark,
                size: AppDimensions.iconMD,
                color: state.isChapterSaved
                    ? AppColors.primary
                    : colorScheme.outline,
              ),
              tooltip: state.isChapterSaved ? 'Remove chapter bookmark' : 'Bookmark chapter',
            );
          },
        ),
        Tooltip(
          message: 'Generate cheat sheet',
          child: IconButton(
            onPressed: () {
              context.pushNamed(
                AppRoutes.cheatSheetName,
                extra: context.read<FormulasCubit>(),
              );
            },
            icon: Icon(LucideIcons.fileText, color: colorScheme.outline),
          ),
        ),
        Tooltip(
          message: 'Study as flashcards',
          child: IconButton(
            onPressed: () {
              final allFormulas = context.read<FormulasCubit>().state.formulas;
              if (allFormulas.isEmpty) return;
              final userId =
                  context.read<AuthCubit>().state.user?.uid ?? '';
              final cards = allFormulas.map((f) => Flashcard(
                id: f.id,
                title: f.title,
                latex: f.latex,
                description: f.description,
                subjectId: '',
                subjectName: '',
                chapterId: '',
                chapterName: '',
              )).toList();
              final cubit = getIt<FlashcardsCubit>();
              cubit.startSession(
                cards: cards,
                userId: userId,
              );
              context.pushNamed(AppRoutes.flashcardsName, extra: cubit);
            },
            icon: Icon(LucideIcons.wand2, color: colorScheme.outline),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingXS),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STAGGERED ENTRANCE ANIMATION
// ═══════════════════════════════════════════════════════════════════

/// Wraps a child widget with a staggered slide-up + fade entrance animation.
class _StaggeredFadeSlide extends StatefulWidget {
  const _StaggeredFadeSlide({
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<_StaggeredFadeSlide> createState() => _StaggeredFadeSlideState();
}

class _StaggeredFadeSlideState extends State<_StaggeredFadeSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.animationSlow,
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: AppDurations.curveDefault,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: AppDurations.curveDefault,
    ));

    // Stagger: each card starts 60ms after the previous one, capped at 600ms
    final delay = Duration(milliseconds: (widget.index * 60).clamp(0, 600));
    Future.delayed(delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  STUDY CARD — THE CORE FORMULA READING UNIT
// ═══════════════════════════════════════════════════════════════════

/// A single formula study card with LaTeX hero, inline visualizer,
/// and streamlined action buttons.
class _StudyCard extends StatefulWidget {
  const _StudyCard({
    required this.formula,
    required this.index,
    required this.totalCount,
  });

  final Formula formula;
  final int index;
  final int totalCount;

  @override
  State<_StudyCard> createState() => _StudyCardState();
}

class _StudyCardState extends State<_StudyCard> {
  bool _descriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final formula = widget.formula;
    final colorScheme = Theme.of(context).colorScheme;
    final hasVisualizer = formula.widgetConfig != null;

    return AppCard(
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header: number + title + overflow menu ──
          _buildHeader(context, formula, colorScheme),

          // ── LaTeX Hero Container ──
          _buildLatexHero(context, formula, colorScheme),

          // ── Description ──
          _buildDescription(context, formula, colorScheme),

          // ── Visualizer (always visible, no toggle) ──
          if (hasVisualizer)
            _buildVisualizer(formula),

          // ── Bottom Action Bar ──
          _buildActionBar(context, formula, colorScheme),
        ],
      ),
    );
  }

  // ────────────── Header ──────────────

  Widget _buildHeader(
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingXL,
        AppDimensions.paddingLG,
        AppDimensions.paddingSM,
        0,
      ),
      child: Row(
        children: [
          // Formula number badge
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primaryContainer],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
            ),
            child: Center(
              child: Text(
                '${widget.index + 1}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: AppDimensions.fontSizeSM,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          // Title
          Expanded(
            child: Text(
              formula.title,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Overflow menu (secondary actions)
          _buildOverflowMenu(context, formula, colorScheme),
        ],
      ),
    );
  }

  // ────────────── Overflow Menu ──────────────

  Widget _buildOverflowMenu(
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    return PopupMenuButton<String>(
      icon: Icon(
        LucideIcons.moreVertical,
        size: AppDimensions.iconMD,
        color: colorScheme.outline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      onSelected: (value) => _handleMenuAction(context, value, formula),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'note',
          child: Row(
            children: [
              Icon(LucideIcons.stickyNote, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Add / Edit Note'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'compare',
          child: Row(
            children: [
              Icon(LucideIcons.gitCompare, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Compare Formula'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(LucideIcons.copy, size: 18, color: colorScheme.onSurface),
              const SizedBox(width: AppDimensions.paddingMD),
              const Text('Copy LaTeX'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, String action, Formula formula) {
    switch (action) {
      case 'note':
        final cubit = context.read<FormulasCubit>();
        cubit.loadFormulaNote(formula.id);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: FormulaNoteSheet(
              formulaId: formula.id,
              formulaTitle: formula.title,
            ),
          ),
        );
      case 'compare':
        final allFormulas = context.read<FormulasCubit>().state.formulas;
        final otherFormulas = allFormulas
            .where((f) => f.id != formula.id)
            .toList();
        if (otherFormulas.isEmpty) return;
        showModalBottomSheet(
          context: context,
          builder: (sheetContext) {
            return _CompareFormulaSheet(
              sourceFormula: formula,
              formulas: otherFormulas,
            );
          },
        );
      case 'copy':
        Clipboard.setData(ClipboardData(text: formula.latex));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('LaTeX copied to clipboard'),
            behavior: SnackBarBehavior.floating,
            duration: AppDurations.delayMedium,
          ),
        );
    }
  }

  // ────────────── LaTeX Hero ──────────────

  Widget _buildLatexHero(
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingXL,
        AppDimensions.paddingLG,
        AppDimensions.paddingXL,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXXL,
          vertical: AppDimensions.paddingSection,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
            width: AppDimensions.borderWidth,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              formula.latex,
              textStyle: AppTextStyles.headlineMedium.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ────────────── Description ──────────────

  Widget _buildDescription(
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingXL,
        AppDimensions.paddingMD,
        AppDimensions.paddingXL,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              formula.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              formula.description,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: AppDimensions.lineHeightRelaxed,
              ),
            ),
            crossFadeState: _descriptionExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: AppDurations.animationFast,
          ),
          if (formula.description.length > 100)
            GestureDetector(
              onTap: () {
                setState(() {
                  _descriptionExpanded = !_descriptionExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimensions.paddingXS),
                child: Text(
                  _descriptionExpanded ? 'Show less' : 'Read more',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                    fontSize: AppDimensions.fontSizeXS,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ────────────── Visualizer (always visible) ──────────────

  Widget _buildVisualizer(Formula formula) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLG,
        AppDimensions.paddingLG,
        AppDimensions.paddingLG,
        0,
      ),
      child: InteractiveWidgetContainer(widgetConfig: formula.widgetConfig!),
    );
  }

  // ────────────── Bottom Action Bar ──────────────

  Widget _buildActionBar(
    BuildContext context,
    Formula formula,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Row(
        children: [
          // Mastery toggle — pill-shaped CTA
          Expanded(
            child: _MasteryToggleButton(
              isMastered: formula.isMastered,
              onToggle: () {
                context.read<FormulasCubit>().toggleMastery(formula);
              },
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMD),
          // Bookmark button
          _BookmarkButton(
            isBookmarked: formula.isBookmarked,
            onToggle: () {
              final subjectName =
                  context
                      .read<SubjectSelectionCubit>()
                      .state
                      .subject
                      ?.name ??
                  AppStrings.unknownSubject;
              final curriculumKey = context
                  .read<CurriculumCubit>()
                  .state
                  .curriculum
                  ?.curriculumKey;

              if (curriculumKey == null || curriculumKey.isEmpty) {
                return;
              }

              context.read<FormulasCubit>().toggleBookmark(
                formula,
                subjectName,
                curriculumKey: curriculumKey,
              );
            },
          ),
        ],
      ),
    );
  }
}


// ═══════════════════════════════════════════════════════════════════
//  MASTERY TOGGLE BUTTON
// ═══════════════════════════════════════════════════════════════════

/// Pill-shaped mastery toggle — the primary CTA on each card.
class _MasteryToggleButton extends StatelessWidget {
  const _MasteryToggleButton({
    required this.isMastered,
    required this.onToggle,
  });

  final bool isMastered;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isMastered
          ? AppColors.secondaryFixed
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: InkWell(
        onTap: () {
          HapticsHelper.mediumImpact();
          onToggle();
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curveDefault,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isMastered ? LucideIcons.checkCircle2 : LucideIcons.circle,
                size: AppDimensions.iconMD,
                color: isMastered
                    ? AppColors.secondary
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppDimensions.paddingSM),
              Text(
                isMastered ? 'Mastered' : 'Mark as Mastered',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isMastered
                      ? AppColors.secondary
                      : colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  BOOKMARK BUTTON
// ═══════════════════════════════════════════════════════════════════

/// Compact bookmark toggle with animated fill.
class _BookmarkButton extends StatelessWidget {
  const _BookmarkButton({
    required this.isBookmarked,
    required this.onToggle,
  });

  final bool isBookmarked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: isBookmarked
          ? AppColors.primaryFixed
          : colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      child: InkWell(
        onTap: () {
          HapticsHelper.lightImpact();
          onToggle();
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        child: AnimatedContainer(
          duration: AppDurations.animationFast,
          curve: AppDurations.curveDefault,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLG,
            vertical: AppDimensions.paddingMD,
          ),
          child: Icon(
            isBookmarked ? Icons.bookmark : LucideIcons.bookmark,
            size: AppDimensions.iconMD,
            color: isBookmarked
                ? AppColors.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
//  COMPARE FORMULA SHEET
// ═══════════════════════════════════════════════════════════════════

class _CompareFormulaSheet extends StatelessWidget {
  const _CompareFormulaSheet({
    required this.sourceFormula,
    required this.formulas,
  });

  final Formula sourceFormula;
  final List<Formula> formulas;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 32, height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Row(
              children: [
                Icon(LucideIcons.gitCompare, color: colorScheme.primary, size: AppDimensions.iconMD),
                const SizedBox(width: AppDimensions.paddingSM),
                Expanded(
                  child: Text(
                    'Compare "${sourceFormula.title}" with:',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            SizedBox(
              height: 240,
              child: ListView.separated(
                itemCount: formulas.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1),
                itemBuilder: (context, index) {
                  final f = formulas[index];
                  return ListTile(
                    leading: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryFixed,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      f.title,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      f.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: Icon(
                      LucideIcons.chevronRight,
                      size: AppDimensions.iconSM,
                      color: colorScheme.outline,
                    ),
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.comparisonName,
                        extra: {'a': sourceFormula, 'b': f},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
