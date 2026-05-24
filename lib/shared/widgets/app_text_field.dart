import 'package:flutter/material.dart';

import '../../core/core.dart';

/// A centralized, globally styled smart text field.
///
/// Follows Material Design floating label behaviors by default. When a user
/// taps on the field, the [label] animates upward to a floating position.
///
/// Supports optional [validator] for form validation (used within a [Form]).
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
  });
  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(
            alpha: AppDimensions.opacityMedium,
          ),
          fontWeight: FontWeight.w600,
        ),
        floatingLabelStyle: AppTextStyles.labelMedium.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(start: AppDimensions.paddingMD),
                child: Icon(
                  prefixIcon,
                  size: AppDimensions.iconDefault,
                  color: colorScheme.outline,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: AppDimensions.avatarMD,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsetsDirectional.only(end: AppDimensions.paddingMD),
                child: suffixIcon,
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(
              alpha: AppDimensions.opacitySubtle,
            ),
            width: AppDimensions.borderWidth,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMD,
          vertical: AppDimensions.paddingMD,
        ),
      ),
    );
  }
}
