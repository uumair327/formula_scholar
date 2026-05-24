import 'package:flutter/material.dart';
import '../../../../core/core.dart';
import 'native_formula_widget.dart';
import 'native_graph_widget.dart';
import 'native_circuit_widget.dart';
import 'native_model3d_widget.dart';
import 'native_image_widget.dart';
import 'native_simulation_widget.dart';
import 'webview_chemistry_widget.dart';

class InteractiveWidgetContainer extends StatefulWidget {
  const InteractiveWidgetContainer({
    super.key,
    required this.widgetConfig,
  });

  final Map<String, dynamic> widgetConfig;

  @override
  State<InteractiveWidgetContainer> createState() => _InteractiveWidgetContainerState();
}

class _InteractiveWidgetContainerState extends State<InteractiveWidgetContainer> {
  final Map<String, double> _parameters = {};
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initParameters();
  }

  @override
  void didUpdateWidget(covariant InteractiveWidgetContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.widgetConfig != oldWidget.widgetConfig) {
      _initParameters();
    }
  }

  void _initParameters() {
    _parameters.clear();
    final config = widget.widgetConfig['config'] as Map<String, dynamic>? ?? {};
    final slidersList = config['sliders'] as List<dynamic>?;
    if (slidersList != null) {
      for (final slider in slidersList) {
        if (slider is Map<String, dynamic>) {
          final id = (slider['id'] ?? slider['variable'] ?? '').toString();
          if (id.isNotEmpty) {
            final double defVal = (slider['default'] ?? slider['value'] ?? 1.0) as double;
            _parameters[id] = defVal;
          }
        }
      }
    }
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final type = widget.widgetConfig['type'] as String? ?? 'formula';
    final config = widget.widgetConfig['config'] as Map<String, dynamic>? ?? {};
    final title = widget.widgetConfig['title'] as String? ?? '';
    final slidersList = config['sliders'] as List<dynamic>?;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Badge / Indicator
          if (title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLG,
                vertical: AppDimensions.paddingSM,
              ),
              child: Row(
                children: [
                  _buildTypeIcon(type, colorScheme),
                  const SizedBox(width: AppDimensions.paddingSM),
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingSM,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                    ),
                    child: Text(
                      type.toUpperCase(),
                      style: AppTextStyles.overline.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Primary Visualization View
          Container(
            height: 280,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              border: Border(
                top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.05)),
                bottom: BorderSide(color: colorScheme.outline.withValues(alpha: 0.05)),
              ),
            ),
            child: _buildVisualizationWidget(type, config),
          ),

          // Sliders / Controls
          if (slidersList != null && slidersList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'PARAMETERS',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingMD),
                  ...slidersList.map((slider) {
                    if (slider is! Map<String, dynamic>) return const SizedBox.shrink();
                    final id = (slider['id'] ?? slider['variable'] ?? '').toString();
                    final label = (slider['label'] ?? id).toString();
                    final minVal = (slider['min'] ?? 0.0) as double;
                    final maxVal = (slider['max'] ?? 10.0) as double;
                    final step = (slider['step'] ?? 0.1) as double;
                    final unit = (slider['unit'] ?? '').toString();

                    final currentVal = _parameters[id] ?? minVal;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                label,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                '${currentVal.toStringAsFixed(1)}${unit.isNotEmpty ? ' $unit' : ''}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              activeTrackColor: colorScheme.primary,
                              inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.2),
                              thumbColor: colorScheme.primary,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                            ),
                            child: Slider(
                              value: currentVal,
                              min: minVal,
                              max: maxVal,
                              divisions: ((maxVal - minVal) / step).round(),
                              onChanged: (newVal) {
                                setState(() {
                                  _parameters[id] = newVal;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(String type, ColorScheme colorScheme) {
    final color = colorScheme.primary;
    const size = 16.0;
    switch (type) {
      case 'graph':
        return Icon(Icons.show_chart, color: color, size: size);
      case 'circuit':
        return Icon(Icons.electrical_services, color: color, size: size);
      case 'model3d':
        return Icon(Icons.view_in_ar, color: color, size: size);
      case 'image':
        return Icon(Icons.image, color: color, size: size);
      case 'simulation':
        return Icon(Icons.play_circle_filled, color: color, size: size);
      case 'chemistry':
        return Icon(Icons.science, color: color, size: size);
      default:
        return Icon(Icons.functions, color: color, size: size);
    }
  }

  Widget _buildVisualizationWidget(String type, Map<String, dynamic> config) {
    switch (type) {
      case 'graph':
        return NativeGraphWidget(config: config, parameters: _parameters);
      case 'circuit':
        return NativeCircuitWidget(config: config, parameters: _parameters);
      case 'model3d':
        return NativeModel3DWidget(config: config, parameters: _parameters);
      case 'image':
        return NativeImageWidget(config: config);
      case 'simulation':
        return NativeSimulationWidget(config: config, parameters: _parameters);
      case 'chemistry':
        return WebviewChemistryWidget(config: config);
      case 'formula':
      default:
        final latex = config['latex'] as String? ?? widget.widgetConfig['latex'] as String? ?? '';
        return Center(child: NativeFormulaWidget(latex: latex));
    }
  }
}
