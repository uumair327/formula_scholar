import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../features/widget_viewer/widget_viewer.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';
import 'compare_formula_sheet.dart';
import 'formula_action_bar.dart';
import 'formula_latex_hero.dart';
import 'formula_note_sheet.dart';
import 'formula_study_card_header.dart';
import 'expandable_description.dart';

class FormulaStudyCard extends StatelessWidget {
  const FormulaStudyCard({
    super.key,
    required this.formula,
    required this.index,
    required this.totalCount,
  });

  final Formula formula;
  final int index;
  final int totalCount;

  void _handleMenuAction(BuildContext context, String action) {
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
            return CompareFormulaSheet(
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

  @override
  Widget build(BuildContext context) {
    final hasVisualizer = formula.widgetConfig != null;

    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      border: Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormulaStudyCardHeader(
            formula: formula,
            index: index,
            onMenuAction: (action) => _handleMenuAction(context, action),
          ),
          FormulaLatexHero(formula: formula),
          ExpandableDescription(formula: formula),
          if (hasVisualizer)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                AppDimensions.paddingLG,
                AppDimensions.paddingLG,
                AppDimensions.paddingLG,
                0,
              ),
              child: InteractiveWidgetContainer(
                widgetConfig: formula.widgetConfig!,
              ),
            ),
          FormulaActionBar(formula: formula),
        ],
      ),
    );
  }
}
