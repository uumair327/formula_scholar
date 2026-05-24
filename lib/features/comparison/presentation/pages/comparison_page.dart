import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../core/domain/entities/formula.dart';
import '../cubit/comparison_cubit.dart';
import '../cubit/comparison_state.dart';
import '../widgets/formula_compare_card.dart';
import '../widgets/similarity_badge.dart';
import '../widgets/variable_comparison.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is Map<String, Formula>) {
        context.read<ComparisonCubit>().setFormulas(extra['a']!, extra['b']!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formula Comparison'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.read<ComparisonCubit>().swap(),
            icon: const Icon(LucideIcons.arrowLeftRight),
            tooltip: 'Swap formulas',
          ),
        ],
      ),
      body: BlocBuilder<ComparisonCubit, ComparisonState>(
        buildWhen: (p, n) => p.status != n.status || p.formulaA != n.formulaA || p.formulaB != n.formulaB || p.comparison != n.comparison,
        builder: (context, state) {
          if (state.status == ComparisonStatus.initial) {
            return const Center(child: Text('Select two formulas to compare'));
          }

          final colorScheme = Theme.of(context).colorScheme;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SimilarityBadge(comparison: state.comparison),
                const SizedBox(height: AppDimensions.paddingLG),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FormulaCompareCard(
                        formula: state.formulaA!,
                        label: 'A',
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Expanded(
                      child: FormulaCompareCard(
                        formula: state.formulaB!,
                        label: 'B',
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                if (state.comparison != null) ...[
                  const SizedBox(height: AppDimensions.paddingLG),
                  VariableComparison(comparison: state.comparison!),
                ],
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
