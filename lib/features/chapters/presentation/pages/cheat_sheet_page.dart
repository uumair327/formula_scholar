import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';
import '../widgets/cheat_sheet_formula_entry.dart';
import '../widgets/cheat_sheet_header.dart';

class CheatSheetPage extends StatelessWidget {
  const CheatSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        titleWidget: Text(
          context.l10n.formulaCheatSheets,
          style: AppTextStyles.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _printCheatSheet(context),
            icon: const Icon(LucideIcons.printer),
            tooltip: context.l10n.printLabel,
          ),
        ],
      ),
      body: BlocBuilder<FormulasCubit, FormulasState>(
        buildWhen: (p, n) =>
            p.formulas != n.formulas || p.chapterName != n.chapterName,
        builder: (context, state) {
          if (state.formulas.isEmpty) {
            return AppEmptyState(
              icon: LucideIcons.fileText,
              title: context.l10n.noFormulasLabel,
              description: 'There are no formulas in this chapter yet.',
            );
          }

          final subjectName = _getSubjectName(context);
          final chapterName = state.chapterName ?? 'Chapter';
          final mastered = state.formulas.where((f) => f.isMastered).length;
          final total = state.formulas.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EntranceWrapper.stagger(
                  index: 0,
                  child: CheatSheetHeader(
                    subject: subjectName,
                    chapter: chapterName,
                    mastered: mastered,
                    total: total,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                ...state.formulas.asMap().entries.map(
                  (entry) => EntranceWrapper.stagger(
                    index: entry.key + 1,
                    child: CheatSheetFormulaEntry(formula: entry.value),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSection),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSubjectName(BuildContext context) {
    try {
      return context.read<SubjectSelectionCubit>().state.subject?.name ??
          'Subject';
    } catch (_) {
      return 'Subject';
    }
  }

  void _printCheatSheet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Print ready — use browser Print or screenshot'),
      ),
    );
  }
}
