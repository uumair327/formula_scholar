library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/domain.dart';
import '../../../../core/core.dart';

class CarouselBanners extends StatelessWidget {
  const CarouselBanners({
    super.key,
    required this.banners,
    required this.currentPage,
    required this.onPageChanged,
  });

  final List<CarouselItem> banners;
  final int currentPage;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.featuredAnnouncements,
          actionLabel: '',
          onAction: () {},
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        CarouselSlider(
          options: CarouselOptions(
            height: 160.0,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            aspectRatio: 16 / 9,
            initialPage: 0,
            onPageChanged: (index, _) {
              onPageChanged(index);
            },
          ),
          items: banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                final bgColor = banner.bgColor != null
                    ? Color(
                        int.parse(banner.bgColor!.replaceFirst('#', '0xFF')),
                      )
                    : colorScheme.primaryContainer;
                return GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse(banner.link);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                  },
                  child: Semantics(
                    button: true,
                    label: banner.title,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXL,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: banner.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, _) => Container(
                              color: bgColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                            errorWidget: (_, _, _) => Container(
                              color: bgColor,
                              child: Center(
                                child: Icon(
                                  LucideIcons.imageOff,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (banners.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingMD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (i) {
                final isActive = i == currentPage;
                return Semantics(
                  label: 'Banner ${i + 1} of ${banners.length}',
                  button: true,
                  child: GestureDetector(
                    onTap: () => onPageChanged(i),
                    child: AnimatedContainer(
                      duration: AppDurations.animationFast,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingXXS,
                      ),
                      width: isActive
                          ? AppDimensions.paddingXXL
                          : AppDimensions.paddingSM,
                      height: AppDimensions.paddingSM - 2,
                      decoration: BoxDecoration(
                        color: isActive
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXXL,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
