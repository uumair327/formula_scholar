import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme configuration.
///
/// Builds a Material 3 [ThemeData] from the custom design tokens.
abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface.withValues(
          alpha: AppDimensions.opacityHigh,
        ),
        elevation: AppDimensions.elevationNone,
        scrolledUnderElevation: AppDimensions.elevationSM,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.onPrimaryFixedVariant,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: AppDimensions.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.onPrimaryFixedVariant,
        unselectedItemColor: AppColors.outline,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationNone,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(AppDimensions.radiusSM),
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? AppColors.outline
                : AppColors.outline.withValues(alpha: AppDimensions.opacityMedium)),
        trackColor: WidgetStateProperty.all(
          AppColors.surfaceVariant.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.inverseSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        secondaryContainer: AppColors.darkSecondaryContainer,
        onSecondaryContainer: AppColors.darkOnSecondaryContainer,
        tertiary: AppColors.darkTertiary,
        onTertiary: AppColors.darkOnTertiary,
        tertiaryContainer: AppColors.darkTertiaryContainer,
        onTertiaryContainer: AppColors.darkOnTertiaryContainer,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOnSurfaceVariant,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.darkOnSurface,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface.withValues(
          alpha: AppDimensions.opacityHigh,
        ),
        elevation: AppDimensions.elevationNone,
        scrolledUnderElevation: AppDimensions.elevationSM,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.darkOnSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceContainerLow,
        elevation: AppDimensions.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkOnSurface,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationNone,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(AppDimensions.radiusSM),
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? AppColors.darkOnSurfaceVariant
                : AppColors.darkOnSurfaceVariant.withValues(alpha: AppDimensions.opacityMedium)),
        trackColor: WidgetStateProperty.all(
          AppColors.darkOnSurfaceVariant.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
    );
  }
}
