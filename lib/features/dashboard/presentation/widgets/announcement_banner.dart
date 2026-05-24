library;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class AnnouncementBanner extends StatefulWidget {
  const AnnouncementBanner({
    super.key,
    required this.announcements,
  });

  final List<AppAnnouncement> announcements;

  @override
  State<AnnouncementBanner> createState() => _AnnouncementBannerState();
}

class _AnnouncementBannerState extends State<AnnouncementBanner> {
  final Set<String> _dismissed = {};
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visible = widget.announcements
        .where((a) => !_dismissed.contains(a.id))
        .toList();

    if (visible.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: visible.length,
          options: CarouselOptions(
            height: 90,
            viewportFraction: 1.0,
            autoPlay: visible.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final announcement = visible[index];
            final isUrgent = announcement.isUrgent;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.all(AppDimensions.paddingLG),
              decoration: BoxDecoration(
                gradient: isUrgent
                    ? (isDark ? AppColors.darkErrorGradient : AppColors.errorGradient)
                    : (isDark ? AppColors.darkPrimaryGradient : AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: const [AppShadows.medium],
              ),
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingSM),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUrgent ? LucideIcons.alertTriangle : LucideIcons.megaphone,
                          color: AppColors.white,
                          size: AppDimensions.iconMD,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              announcement.title,
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              announcement.message,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.white.withValues(alpha: 0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingXL),
                    ],
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: IconButton(
                      icon: const Icon(LucideIcons.x, color: AppColors.white, size: 20),
                      onPressed: () {
                        setState(() {
                          _dismissed.add(announcement.id);
                          if (_currentIndex >= visible.length - 1) {
                            _currentIndex = 0;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (visible.length > 1) ...[
          const SizedBox(height: AppDimensions.paddingSM),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: visible.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == entry.key
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.2),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
