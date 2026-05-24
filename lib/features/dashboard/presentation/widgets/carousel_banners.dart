library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

class CarouselBanners extends StatefulWidget {
  const CarouselBanners({
    super.key,
    required this.banners,
  });

  final List<CarouselItem> banners;

  @override
  State<CarouselBanners> createState() => _CarouselBannersState();
}

class _CarouselBannersState extends State<CarouselBanners> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: AppStrings.featuredAnnouncements,
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
              setState(() => _currentPage = index);
            },
          ),
          items: widget.banners.map((banner) {
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
        if (widget.banners.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.paddingMD),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.banners.length, (i) {
                final isActive = i == _currentPage;
                return Semantics(
                  label: 'Banner ${i + 1} of ${widget.banners.length}',
                  button: true,
                  child: GestureDetector(
                    onTap: () => _currentPage = i,
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
