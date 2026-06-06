import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/interactive_widget_container.dart';

class WidgetPreviewScreen extends StatelessWidget {
  const WidgetPreviewScreen({super.key, this.configB64});

  final String? configB64;

  @override
  Widget build(BuildContext context) {
    if (configB64 == null || configB64!.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'No configuration provided.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    Map<String, dynamic>? widgetConfig;
    try {
      // Dart's base64Url.decode pads automatically if length is valid, but let's normalize length
      final padding = (4 - configB64!.length % 4) % 4;
      final normalized = configB64!.padRight(configB64!.length + padding, '=');
      final jsonStr = utf8.decode(base64Url.decode(normalized));
      widgetConfig = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (e) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Invalid configuration: $e',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: InteractiveWidgetContainer(widgetConfig: widgetConfig),
      ),
    );
  }
}
