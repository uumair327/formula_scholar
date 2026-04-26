import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

/// Reusable circular avatar with cached network image, placeholder, and error
/// fallback.
///
/// Replaces the repeated ClipOval + CachedNetworkImage + placeholder/error
/// pattern found in every app bar and profile hero across the project.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.imageUrl,
    this.size = AppDimensions.avatarMD,
    this.placeholderColor = AppColors.primaryFixed,
    this.border,
    this.fallbackIcon = Icons.person,
    this.fallbackIconSize = AppDimensions.iconMD,
    this.fallbackIconColor = AppColors.onSurfaceVariant,
  });

  /// The network image URL to display.
  final String imageUrl;

  /// Diameter of the avatar.
  final double size;

  /// Background / placeholder colour.
  final Color placeholderColor;

  /// Optional border configuration.
  final Border? border;

  /// Fallback icon shown on load failure.
  final IconData fallbackIcon;

  /// Size of the fallback icon.
  final double fallbackIconSize;

  /// Colour of the fallback icon.
  final Color fallbackIconColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: placeholderColor,
            border: border,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: placeholderColor,
            border: border,
          ),
          child: Icon(
            fallbackIcon,
            size: fallbackIconSize,
            color: fallbackIconColor,
          ),
        ),
      ),
    );
  }
}
