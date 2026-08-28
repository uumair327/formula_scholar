import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../../../visualizer_3d/visualizer_3d.dart';
import '../../domain/entities/formula.dart';

class HologramStatIndicator extends StatelessWidget {
  const HologramStatIndicator({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingSM,
        vertical: AppDimensions.paddingXS,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 8,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class VisualizerFormulaSelector extends StatelessWidget {
  const VisualizerFormulaSelector({
    super.key,
    required this.subjectFormulas,
    required this.selectedFormulaIndex,
    required this.onPrevious,
    required this.onNext,
  });

  final List<Formula> subjectFormulas;
  final int selectedFormulaIndex;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STUDY REFERENCE',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                '${selectedFormulaIndex + 1} of ${subjectFormulas.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          AppCard(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? LucideIcons.chevronRight
                        : LucideIcons.chevronLeft,
                  ),
                  tooltip: context.l10n.previousFormula,
                  onPressed: onPrevious,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        subjectFormulas[selectedFormulaIndex].title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.paddingXS),
                      Text(
                        subjectFormulas[selectedFormulaIndex].latex,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? LucideIcons.chevronLeft
                        : LucideIcons.chevronRight,
                  ),
                  tooltip: context.l10n.nextFormula,
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VisualizerControlsPanel extends StatelessWidget {
  const VisualizerControlsPanel({
    super.key,
    required this.formula,
    required this.paramA,
    required this.paramB,
    required this.paramC,
    required this.onParamAChanged,
    required this.onParamBChanged,
    required this.onParamCChanged,
    required this.visualizerType,
  });

  final Formula formula;
  final double paramA;
  final double paramB;
  final double paramC;
  final ValueChanged<double> onParamAChanged;
  final ValueChanged<double> onParamBChanged;
  final ValueChanged<double> onParamCChanged;
  final VisualizerType visualizerType;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    String labelA = 'Radius';
    String labelB = 'Height';
    String labelC = 'Rotation';

    if (visualizerType == VisualizerType.frustum) {
      labelA = 'Bottom Radius';
      labelB = 'Top Radius';
      labelC = 'Height';
    } else if (visualizerType == VisualizerType.gravitation) {
      labelA = 'Mass Factor';
      labelB = 'Orbit Distance';
      labelC = 'Orbital Speed';
    } else if (visualizerType == VisualizerType.refraction) {
      labelA = 'Beam Angle';
      labelB = 'Prism Size';
      labelC = 'Refraction Index';
    } else if (visualizerType == VisualizerType.quadratic) {
      labelA = 'Variable A';
      labelB = 'Variable B';
      labelC = 'Variable C';
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      child: AppCard(
        child: Column(
          children: [
            _SliderRow(
              label: labelA,
              value: paramA,
              min: 0.2,
              max: 2.0,
              onChanged: onParamAChanged,
              colorScheme: colorScheme,
            ),
            _SliderRow(
              label: labelB,
              value: paramB,
              min: 0.5,
              max: 2.5,
              onChanged: onParamBChanged,
              colorScheme: colorScheme,
            ),
            _SliderRow(
              label: labelC,
              value: paramC,
              min: 0.1,
              max: 2.0,
              onChanged: onParamCChanged,
              colorScheme: colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.colorScheme,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.2),
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withValues(alpha: 0.1),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            value.toStringAsFixed(2),
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
