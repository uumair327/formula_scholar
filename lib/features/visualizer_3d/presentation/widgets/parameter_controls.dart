import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class ParameterControls extends StatelessWidget {
  const ParameterControls({
    super.key,
    required this.type,
    required this.paramA,
    required this.paramB,
    required this.paramC,
    required this.onChangedA,
    required this.onChangedB,
    required this.onChangedC,
  });

  final VisualizerType type;
  final double paramA;
  final double paramB;
  final double paramC;
  final ValueChanged<double> onChangedA;
  final ValueChanged<double> onChangedB;
  final ValueChanged<double> onChangedC;

  String _labelA() {
    switch (type) {
      case VisualizerType.gravitation: return 'Mass Factor';
      case VisualizerType.refraction: return 'Beam Angle';
      case VisualizerType.quadratic: return 'Variable A';
      default: return 'Radius';
    }
  }

  String _labelB() {
    switch (type) {
      case VisualizerType.gravitation: return 'Orbit Distance';
      case VisualizerType.refraction: return 'Prism Size';
      case VisualizerType.quadratic: return 'Variable B';
      default: return 'Height';
    }
  }

  String _labelC() {
    switch (type) {
      case VisualizerType.gravitation: return 'Orbital Speed';
      case VisualizerType.refraction: return 'Refraction Index';
      case VisualizerType.quadratic: return 'Variable C';
      default: return 'Rotation';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      child: Column(
        children: [
          _buildSlider(_labelA(), paramA, 0.2, 2.0, onChangedA, colorScheme),
          _buildSlider(_labelB(), paramB, 0.5, 2.5, onChangedB, colorScheme),
          _buildSlider(_labelC(), paramC, 0.1, 2.0, onChangedC, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingXXS),
      child: Row(
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
                value: value.clamp(min, max),
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
      ),
    );
  }
}
