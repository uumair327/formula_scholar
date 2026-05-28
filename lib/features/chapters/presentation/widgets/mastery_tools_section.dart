import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../../../flashcards/flashcards.dart';
import '../../../profile/profile.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/mastery_tools_cubit.dart';
import 'mastery_tool_grid_tile.dart';

class MasteryToolsSection extends StatelessWidget {
  const MasteryToolsSection({
    super.key,
    required this.tools,
    required this.subjectId,
    required this.chapters,
  });

  final List<MasteryTool> tools;
  final String subjectId;
  final List<Chapter> chapters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: context.l10n.masteryTools,
          leadingIcon: LucideIcons.sparkles,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        if (tools.isEmpty)
          AppCard(
            boxShadow: const [AppShadows.subtle],
            child: Row(
              children: [
                Icon(
                  LucideIcons.info,
                  color: colorScheme.primary,
                  size: AppDimensions.iconLG,
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: Text(
                    context.l10n.masteryToolsSyncing,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppDimensions.masteryToolsCrossAxisCount,
              mainAxisSpacing: AppDimensions.masteryToolsSpacing,
              crossAxisSpacing: AppDimensions.masteryToolsSpacing,
              childAspectRatio: AppDimensions.masteryToolsAspectRatio,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return MasteryToolGridTile(
                tool: tool,
                onTap: () => _onToolTap(context, tool),
              );
            },
          ),
      ],
    );
  }

  void _onToolTap(BuildContext context, MasteryTool tool) {
    if (!tool.isEnabled) {
      _showUnimplementedSheet(context, tool);
      return;
    }

    if (tool.routeName == 'cheatSheet') {
      unawaited(_handleCheatSheetTap(context));
      return;
    }

    if (tool.routeName == 'flashcards') {
      unawaited(_handleFlashcardsTap(context));
      return;
    }

    if (tool.routeName == 'visualizer_3d') {
      unawaited(_handleVisualizer3dTap(context));
      return;
    }

    if (_navigateForRoute(context, tool.routeName)) {
      return;
    }

    _showUnimplementedSheet(context, tool);
  }

  // ──────────────────────── Async Subject Formulas Loader ───────────────────────

  Future<List<Formula>?> _prepareFormulas(
    BuildContext context,
    String message,
    String? curriculumKey,
  ) async {
    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            child: Center(
              child: AppCard(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppDimensions.paddingLG),
                    Text(
                      message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    try {
      final cubit = context.read<MasteryToolsCubit>();
      final allFormulas = await cubit.prepareFormulas(
        subjectId,
        chapters,
        curriculumKey,
      );
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      return allFormulas;
    } catch (e, st) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      AppLogger.error(
        'Failed to prepare subject formulas',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<void> _handleCheatSheetTap(BuildContext context) async {
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;

    final formulas = await _prepareFormulas(
      context,
      'Syncing formulas...',
      curriculumKey,
    );
    if (!context.mounted) return;

    if (formulas == null || formulas.isEmpty) {
      _showErrorSnackBar(context, 'No formulas found for this subject.');
      return;
    }

    final formulasCubit = getIt<FormulasCubit>();
    formulasCubit.loadDirectFormulas(
      formulas: formulas,
      subjectId: subjectId,
      chapterName: 'Subject Reference',
    );

    await context.pushNamed(AppRoutes.cheatSheetName, extra: formulasCubit);
  }

  Future<void> _handleFlashcardsTap(BuildContext context) async {
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;
    final userId = context.read<AuthCubit>().state.user?.uid ?? '';

    final formulas = await _prepareFormulas(
      context,
      'Generating flashcards...',
      curriculumKey,
    );
    if (!context.mounted) return;

    if (formulas == null || formulas.isEmpty) {
      _showErrorSnackBar(context, 'No formulas found for this subject.');
      return;
    }

    final cards = formulas
        .map(
          (f) => Flashcard(
            id: f.id,
            title: f.title,
            latex: f.latex,
            description: f.description,
            subjectId: subjectId,
            subjectName: '',
            chapterId: '',
            chapterName: '',
          ),
        )
        .toList();

    final flashcardsCubit = getIt<FlashcardsCubit>();
    await flashcardsCubit.startSession(cards: cards, userId: userId);

    if (!context.mounted) return;
    await context.pushNamed(AppRoutes.flashcardsName, extra: flashcardsCubit);
  }

  Future<void> _handleVisualizer3dTap(BuildContext context) async {
    final curriculumKey = context
        .read<CurriculumCubit>()
        .state
        .curriculum
        ?.curriculumKey;

    final formulas = await _prepareFormulas(
      context,
      'Preparing 3D visuals...',
      curriculumKey,
    );
    if (!context.mounted) return;

    if (formulas == null || formulas.isEmpty) {
      _showErrorSnackBar(context, 'No formulas found for this subject.');
      return;
    }

    final formulasCubit = getIt<FormulasCubit>();
    formulasCubit.loadDirectFormulas(
      formulas: formulas,
      subjectId: subjectId,
      chapterName: 'Subject Visualizer',
    );

    await context.pushNamed(AppRoutes.visualizer3dName, extra: formulasCubit);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showUnimplementedSheet(BuildContext context, MasteryTool tool) {
    final subtitle = _getToolSubtitle(context, tool);
    SupportContactSheet.show(
      context,
      title: tool.label,
      subtitle: subtitle,
      email: context.l10n.supportEmail,
    );
  }

  String _getToolSubtitle(BuildContext context, MasteryTool tool) {
    if (tool.supportSubtitle != null && tool.supportSubtitle!.isNotEmpty) {
      return tool.supportSubtitle!;
    }

    if (tool.label == context.l10n.videoLessons) {
      return 'Video Lessons are currently being prepared. Contact support if you need access to guided tutorial content.';
    } else if (tool.label == context.l10n.cheatSheets) {
      return 'Cheat Sheets provide quick formula reference guides. Contact support to request this feature for your curriculum.';
    } else if (tool.label == context.l10n.visualizer3d) {
      return '3D Visualizer helps understand geometric concepts. Contact support to request 3D visualization tools.';
    }
    return 'This feature is not yet available. Contact support for more information.';
  }

  bool _navigateForRoute(BuildContext context, String? routeName) {
    if (routeName == null || routeName.isEmpty) {
      return false;
    }

    final shell = StatefulNavigationShell.of(context);
    switch (routeName) {
      case 'dashboard':
        shell.goBranch(0);
        return true;
      case 'chapters':
        shell.goBranch(1);
        return true;
      case 'practice':
        shell.goBranch(2);
        return true;
      case 'saved':
        shell.goBranch(3);
        return true;
      default:
        return false;
    }
  }
}
