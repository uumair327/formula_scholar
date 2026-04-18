import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/core.dart';

/// 404 / Not Found page displayed when [GoRouter] cannot match a route.
///
/// Registered via [GoRouter.errorBuilder]. Provides a clear message
/// and a button to navigate back to the dashboard.
class NotFoundPage extends StatelessWidget {

  const NotFoundPage({super.key, required this.state});
  /// The [GoRouterState] containing the unmatched URI.
  final GoRouterState state;

  @override
  Widget build(BuildContext context) {
    AppLogger.warning(
      'Not found page shown for: ${state.uri}',
      tag: AppLogTags.router,
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXL,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppDimensions.avatarProfile,
                height: AppDimensions.avatarProfile,
                decoration: const BoxDecoration(
                  color: AppColors.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.mapPinOff,
                  size: AppDimensions.iconHero,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingHero),
              Text(
                AppStrings.pageNotFound,
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.pageNotFoundDescription,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppLogger.info(
                      'Navigating home from 404',
                      tag: AppLogTags.router,
                    );
                    context.goNamed(AppRoutes.dashboardName);
                  },
                  icon: const Icon(
                    LucideIcons.home,
                    size: AppDimensions.iconMD,
                  ),
                  label: const Text(AppStrings.goHome),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingLG,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXXL,
                      ),
                    ),
                    textStyle: AppTextStyles.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
