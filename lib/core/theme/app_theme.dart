import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_dimensions.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme configuration.
///
/// Builds a Material 3 [ThemeData] from the custom design tokens.
/// Includes component themes for buttons, inputs, dialogs, chips,
/// snack bars, bottom sheets, and page transitions for a premium feel.
abstract final class AppTheme {
  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    const colorScheme = ColorScheme.light(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(),
      appBarTheme: _buildAppBarTheme(
        bg: AppColors.surface,
        fg: AppColors.onPrimaryFixedVariant,
      ),
      cardTheme: _buildCardTheme(AppColors.surfaceContainerLowest),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.onPrimaryFixedVariant,
        unselectedItemColor: AppColors.outline,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationNone,
      ),
      // ── Buttons ──
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      // ── Inputs ──
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      // ── Chips ──
      chipTheme: _buildChipTheme(colorScheme),
      // ── Dialogs & Sheets ──
      dialogTheme: _buildDialogTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      tooltipTheme: _buildTooltipTheme(colorScheme),
      // ── Snack Bar ──
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        thickness: 1.0,
        space: 1.0,
      ),
      // ── Scrollbar ──
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(AppDimensions.radiusSM),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? AppColors.outline
              : AppColors.outline.withValues(
                  alpha: AppDimensions.opacityMedium,
                ),
        ),
        trackColor: WidgetStateProperty.all(
          AppColors.surfaceVariant.withValues(
            alpha: AppDimensions.opacitySubtle,
          ),
        ),
      ),
      // ── Page Transitions ──
      pageTransitionsTheme: _buildPageTransitions(),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    const colorScheme = ColorScheme.dark(
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
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkSurface,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(dark: true),
      appBarTheme: _buildAppBarTheme(
        bg: AppColors.darkSurface,
        fg: AppColors.darkOnSurface,
      ),
      cardTheme: _buildCardTheme(AppColors.darkSurfaceContainerLow),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkOnSurface,
        unselectedItemColor: AppColors.darkOnSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: AppDimensions.elevationNone,
      ),
      // ── Buttons ──
      elevatedButtonTheme: _buildElevatedButtonTheme(colorScheme),
      filledButtonTheme: _buildFilledButtonTheme(colorScheme),
      outlinedButtonTheme: _buildOutlinedButtonTheme(colorScheme),
      textButtonTheme: _buildTextButtonTheme(colorScheme),
      // ── Inputs ──
      inputDecorationTheme: _buildInputDecorationTheme(colorScheme),
      // ── Chips ──
      chipTheme: _buildChipTheme(colorScheme),
      // ── Dialogs & Sheets ──
      dialogTheme: _buildDialogTheme(colorScheme),
      bottomSheetTheme: _buildBottomSheetTheme(colorScheme),
      tooltipTheme: _buildTooltipTheme(colorScheme),
      // ── Snack Bar ──
      snackBarTheme: _buildSnackBarTheme(colorScheme),
      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.2),
        thickness: 1.0,
        space: 1.0,
      ),
      // ── Scrollbar ──
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStateProperty.all(8.0),
        radius: const Radius.circular(AppDimensions.radiusSM),
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? AppColors.darkOnSurfaceVariant
              : AppColors.darkOnSurfaceVariant.withValues(
                  alpha: AppDimensions.opacityMedium,
                ),
        ),
        trackColor: WidgetStateProperty.all(
          AppColors.darkOnSurfaceVariant.withValues(
            alpha: AppDimensions.opacitySubtle,
          ),
        ),
      ),
      // ── Page Transitions ──
      pageTransitionsTheme: _buildPageTransitions(),
    );
  }

  static TooltipThemeData _buildTooltipTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurfaceContainerHigh
        : colorScheme.inverseSurface;
    final onSurfaceColor = isDark
        ? AppColors.darkOnSurface
        : colorScheme.onInverseSurface;

    return TooltipThemeData(
      waitDuration: kIsWeb ? Duration.zero : const Duration(milliseconds: 250),
      showDuration: const Duration(seconds: 2),
      exitDuration: const Duration(milliseconds: 100),
      preferBelow: true,
      verticalOffset: AppDimensions.paddingMD,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      margin: const EdgeInsets.all(AppDimensions.paddingSM),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.16),
            blurRadius: AppDimensions.blurRadiusMD,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: AppTextStyles.labelSmall.copyWith(
        color: onSurfaceColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // COMPONENT THEME BUILDERS
  // ═══════════════════════════════════════════════════════════════

  static TextTheme _buildTextTheme({bool dark = false}) {
    final color = dark ? AppColors.darkOnSurface : null;
    return TextTheme(
      displayLarge: dark
          ? AppTextStyles.displayLarge.copyWith(color: color)
          : AppTextStyles.displayLarge,
      headlineLarge: dark
          ? AppTextStyles.headlineLarge.copyWith(color: color)
          : AppTextStyles.headlineLarge,
      headlineMedium: dark
          ? AppTextStyles.headlineMedium.copyWith(color: color)
          : AppTextStyles.headlineMedium,
      headlineSmall: dark
          ? AppTextStyles.headlineSmall.copyWith(color: color)
          : AppTextStyles.headlineSmall,
      titleLarge: dark
          ? AppTextStyles.titleLarge.copyWith(color: color)
          : AppTextStyles.titleLarge,
      titleMedium: dark
          ? AppTextStyles.titleMedium.copyWith(color: color)
          : AppTextStyles.titleMedium,
      titleSmall: dark
          ? AppTextStyles.titleSmall.copyWith(color: color)
          : AppTextStyles.titleSmall,
      bodyLarge: dark
          ? AppTextStyles.bodyLarge.copyWith(color: color)
          : AppTextStyles.bodyLarge,
      bodyMedium: dark
          ? AppTextStyles.bodyMedium.copyWith(color: color)
          : AppTextStyles.bodyMedium,
      bodySmall: dark
          ? AppTextStyles.bodySmall.copyWith(color: color)
          : AppTextStyles.bodySmall,
      labelLarge: dark
          ? AppTextStyles.labelLarge.copyWith(color: color)
          : AppTextStyles.labelLarge,
      labelMedium: dark
          ? AppTextStyles.labelMedium.copyWith(color: color)
          : AppTextStyles.labelMedium,
      labelSmall: dark
          ? AppTextStyles.labelSmall.copyWith(color: color)
          : AppTextStyles.labelSmall,
    );
  }

  static AppBarTheme _buildAppBarTheme({required Color bg, required Color fg}) {
    return AppBarTheme(
      backgroundColor: bg.withValues(alpha: AppDimensions.opacityHigh),
      elevation: AppDimensions.elevationNone,
      scrolledUnderElevation: AppDimensions.elevationSM,
      centerTitle: false,
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(color: fg),
    );
  }

  static CardThemeData _buildCardTheme(Color color) {
    return CardThemeData(
      color: color,
      elevation: AppDimensions.elevationNone,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
    );
  }

  // ── Buttons ──────────────────────────────────────────────────

  static ElevatedButtonThemeData _buildElevatedButtonTheme(ColorScheme cs) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXXL,
          vertical: AppDimensions.paddingLG,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static FilledButtonThemeData _buildFilledButtonTheme(ColorScheme cs) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXXL,
          vertical: AppDimensions.paddingLG,
        ),
        shape: const StadiumBorder(),
        textStyle: AppTextStyles.labelLarge.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _buildOutlinedButtonTheme(ColorScheme cs) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingMD,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        ),
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
        textStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme(ColorScheme cs) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLG,
          vertical: AppDimensions.paddingSM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        ),
        textStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ── Input Decoration ─────────────────────────────────────────

  static InputDecorationTheme _buildInputDecorationTheme(ColorScheme cs) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      borderSide: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.5)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      borderSide: BorderSide(color: cs.primary, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      borderSide: BorderSide(color: cs.error),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: cs.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLG,
        vertical: AppDimensions.paddingLG,
      ),
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: cs.onSurfaceVariant),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      prefixIconColor: cs.onSurfaceVariant,
      suffixIconColor: cs.onSurfaceVariant,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  // ── Chips ────────────────────────────────────────────────────

  static ChipThemeData _buildChipTheme(ColorScheme cs) {
    return ChipThemeData(
      backgroundColor: cs.surfaceContainerLow,
      selectedColor: cs.primaryContainer.withValues(alpha: 0.3),
      labelStyle: AppTextStyles.labelMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.chipPaddingHorizontal,
        vertical: AppDimensions.chipPaddingVertical,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      side: BorderSide.none,
    );
  }

  // ── Dialogs ──────────────────────────────────────────────────

  static DialogThemeData _buildDialogTheme(ColorScheme cs) {
    return DialogThemeData(
      backgroundColor: cs.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
      ),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(
        color: cs.onSurface,
        fontWeight: FontWeight.w800,
      ),
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: cs.onSurfaceVariant,
      ),
    );
  }

  // ── Bottom Sheet ─────────────────────────────────────────────

  static BottomSheetThemeData _buildBottomSheetTheme(ColorScheme cs) {
    return BottomSheetThemeData(
      backgroundColor: cs.surface,
      modalBackgroundColor: cs.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusShell),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: cs.outlineVariant.withValues(alpha: 0.5),
      dragHandleSize: const Size(40, 4),
    );
  }

  // ── Snack Bar ────────────────────────────────────────────────

  static SnackBarThemeData _buildSnackBarTheme(ColorScheme cs) {
    return SnackBarThemeData(
      backgroundColor: cs.inverseSurface,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: cs.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXL,
        vertical: AppDimensions.paddingMD,
      ),
    );
  }

  // ── Page Transitions ─────────────────────────────────────────

  static PageTransitionsTheme _buildPageTransitions() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      },
    );
  }
}
