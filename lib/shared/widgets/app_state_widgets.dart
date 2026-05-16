import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable error state widget displayed when a feature page fails to load.
///
/// Replaces the duplicated error Scaffold(Column(Icon + Text + ElevatedButton))
/// pattern found in DashboardPage and ProfilePage.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.message,
    required this.onRetry,
    this.retryLabel = AppStrings.retry,
  });

  /// The error message to display. Falls back to [AppStrings.somethingWentWrong].
  final String? message;

  /// Callback when the retry button is pressed.
  final VoidCallback onRetry;

  /// Optional retry button label. Defaults to [AppStrings.retry].
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXXL,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppDimensions.iconHero,
              color: colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              message ?? AppStrings.somethingWentWrong,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLG),
            ElevatedButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}

/// Reusable loading state widget.
///
/// Replaces the duplicated `Scaffold(Center(CircularProgressIndicator))`
/// pattern found in all four feature pages.
class AppLoadingState extends StatelessWidget {
  const AppLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
