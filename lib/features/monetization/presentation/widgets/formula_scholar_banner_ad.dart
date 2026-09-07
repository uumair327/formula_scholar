import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/ad_placement.dart';
import '../cubits/ad/ad_cubit.dart';
import '../cubits/ad/ad_state.dart';
import '../cubits/premium/premium_cubit.dart';
import '../cubits/premium/premium_state.dart';
import 'premium_paywall_sheet.dart';

/// Smart responsive banner ad container.
///
/// Features:
/// - Automatically collapses (`SizedBox.shrink()`) if the user is Premium.
/// - Respects `AdDensityLevel` and `FeatureFlag.bannerAdsEnabled`.
/// - Clean STEM learning card design with quick "Go Super" trigger.
class FormulaScholarBannerAd extends StatefulWidget {
  const FormulaScholarBannerAd({
    super.key,
    this.placement = AdPlacement.dashboardBanner,
    this.margin,
  });

  final AdPlacement placement;
  final EdgeInsetsGeometry? margin;

  @override
  State<FormulaScholarBannerAd> createState() => _FormulaScholarBannerAdState();
}

class _FormulaScholarBannerAdState extends State<FormulaScholarBannerAd> {
  bool _dismissedThisSession = false;

  void _openPaywall() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const PremiumPaywallSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissedThisSession) return const SizedBox.shrink();

    return BlocBuilder<PremiumCubit, PremiumState>(
      builder: (context, premiumState) {
        // Zero-Ad Guarantee: Immediately collapse if user is premium.
        if (premiumState.isPremium) return const SizedBox.shrink();

        return BlocBuilder<AdCubit, AdState>(
          builder: (context, adState) {
            // Collapse if ad density disallows banners
            if (!adState.densityLevel.bannerAllowed) {
              return const SizedBox.shrink();
            }

            final colorScheme = Theme.of(context).colorScheme;

            return Container(
              margin: widget.margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(LucideIcons.zap, size: 18, color: colorScheme.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: _openPaywall,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                'FORMULA SCHOLAR FREE',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: colorScheme.primary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'GO SUPER 💎',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF818CF8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Master 10,000+ formulas with 0 ads & unlimited quizzes.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () => setState(() => _dismissedThisSession = true),
                    tooltip: 'Hide for now',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
