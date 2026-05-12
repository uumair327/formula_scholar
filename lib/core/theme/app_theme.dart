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
        primary: AppColors.primaryFixedDim,
        onPrimary: AppColors.onPrimaryFixed,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondaryFixedDim,
        onSecondary: AppColors.onSecondaryFixed,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiaryFixedDim,
        onTertiary: AppColors.onTertiaryFixed,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        surface: AppColors.inverseSurface,
        onSurface: AppColors.inverseOnSurface,
        onSurfaceVariant: AppColors.surfaceContainerHighest,
        outline: AppColors.outlineVariant,
        outlineVariant: AppColors.surfaceVariant,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.inverseOnSurface,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.inverseOnSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.inverseSurface.withValues(
          alpha: AppDimensions.opacityHigh,
        ),
        elevation: AppDimensions.elevationNone,
        scrolledUnderElevation: AppDimensions.elevationSM,
        centerTitle: false,
        titleTextStyle: AppTextStyles.headlineSmall.copyWith(
          color: AppColors.inverseOnSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLow,
        elevation: AppDimensions.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.inverseSurface,
        selectedItemColor: AppColors.inverseOnSurface,
        unselectedItemColor: AppColors.outlineVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationNone,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(AppDimensions.radiusSM),
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.hovered)
                ? AppColors.outlineVariant
                : AppColors.outlineVariant.withValues(alpha: AppDimensions.opacityMedium)),
        trackColor: WidgetStateProperty.all(
          AppColors.surfaceVariant.withValues(alpha: AppDimensions.opacitySubtle),
        ),
      ),
    );
  }
}
