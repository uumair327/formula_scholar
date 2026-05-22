import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/core.dart';

class NativeImageWidget extends StatefulWidget {
  const NativeImageWidget({
    super.key,
    required this.config,
  });

  final Map<String, dynamic> config;

  @override
  State<NativeImageWidget> createState() => _NativeImageWidgetState();
}

class _NativeImageWidgetState extends State<NativeImageWidget>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _selectedAnnotation;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final url = widget.config['url'] as String? ?? '';
    final annotations = widget.config['annotations'] as List<dynamic>? ?? [];

    return Stack(
      children: [
        // Interactive Viewer with Zoom/Pan
        InteractiveViewer(
          maxScale: 4.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;

              return Stack(
                children: [
                  Positioned.fill(
                    child: url.isNotEmpty
                        ? (url.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => _buildPlaceholderImage(),
                              )
                            : Image.asset(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                              ))
                        : _buildPlaceholderImage(),
                  ),

                  // Overlay annotations
                  ...annotations.map((ann) {
                    if (ann is! Map<String, dynamic>) return const SizedBox.shrink();
                    final x = (ann['x'] ?? 0.5) as double;
                    final y = (ann['y'] ?? 0.5) as double;

                    return Positioned(
                      left: x * width - 15,
                      top: y * height - 15,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAnnotation = ann;
                          });
                        },
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale = 1.0 + (_pulseController.value * 0.25);
                            return SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 24 * scale,
                                      height: 24 * scale,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withValues(alpha: 0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ),

        // Information Overlay Sheet at the bottom
        if (_selectedAnnotation != null)
          Positioned(
            bottom: AppDimensions.paddingMD,
            left: AppDimensions.paddingMD,
            right: AppDimensions.paddingMD,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingMD),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedAnnotation!['title'] as String? ?? 'Annotation',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedAnnotation!['description'] as String? ?? '',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colorScheme.outline, size: 18),
                    onPressed: () {
                      setState(() {
                        _selectedAnnotation = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey.shade900,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey.shade700),
            const SizedBox(height: 8),
            Text(
              'Optical Ray Diagram',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
