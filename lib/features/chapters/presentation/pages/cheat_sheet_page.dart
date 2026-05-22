import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/entities/formula.dart';
import '../cubit/formulas_cubit.dart';
import '../cubit/formulas_state.dart';

class CheatSheetPage extends StatelessWidget {
  const CheatSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        titleWidget: Text(
          'Cheat Sheet',
          style: AppTextStyles.titleMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _printCheatSheet(context),
            icon: const Icon(LucideIcons.printer),
            tooltip: 'Print',
          ),
        ],
      ),
      body: BlocBuilder<FormulasCubit, FormulasState>(
        builder: (context, state) {
          if (state.formulas.isEmpty) {
            return const AppEmptyState(
              icon: LucideIcons.fileText,
              title: 'No formulas',
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
                  child: _buildHeader(context, subjectName, chapterName, mastered, total),
                ),
                const SizedBox(height: AppDimensions.paddingLG),
                ...state.formulas.asMap().entries.map(
                  (entry) => EntranceWrapper.stagger(
                    index: entry.key + 1,
                    child: _buildFormulaEntry(context, entry.value),
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

  Widget _buildHeader(
    BuildContext context,
    String subject,
    String chapter,
    int mastered,
    int total,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(LucideIcons.fileText, color: colorScheme.primary),
                const SizedBox(width: AppDimensions.paddingSM),
                Text(
                  subject.toUpperCase(),
                  style: AppTextStyles.overline.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              chapter,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            Row(
              children: [
                _StatChip(
                  icon: LucideIcons.checkCircle,
                  label: '$mastered/$total mastered',
                  color: colorScheme.secondary,
                ),
                const SizedBox(width: AppDimensions.paddingSM),
                _StatChip(
                  icon: LucideIcons.fileText,
                  label: '$total formulas',
                  color: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildFormulaEntry(BuildContext context, Formula formula) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingMD),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formula.title,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (formula.isMastered)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingSM,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSM,
                        ),
                      ),
                      child: Text(
                        'MASTERED',
                        style: AppTextStyles.overline.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingMD),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingLG),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Math.tex(
                      formula.latex,
                      textStyle: AppTextStyles.headlineMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
              if (formula.description.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.paddingSM),
                Text(
                  formula.description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }

  void _printCheatSheet(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print ready — use browser Print or screenshot')),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final dynamic icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
