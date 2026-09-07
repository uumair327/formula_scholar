import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/ad_density_level.dart';
import '../../domain/entities/ad_placement.dart';
import '../../domain/entities/ad_reward.dart';
import '../cubits/ad/ad_cubit.dart';
import '../cubits/ad/ad_state.dart';
import '../cubits/premium/premium_cubit.dart';
import '../cubits/premium/premium_state.dart';
import '../widgets/formula_scholar_banner_ad.dart';

/// Developer & QA console for validating ad density, Duolingo window, and zero-ad policy.
class MonetizationDebugPage extends StatelessWidget {
  const MonetizationDebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111726),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Monetization & Ads Console',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Banner Ad Preview
            const Text(
              'LIVE BANNER PREVIEW (Collapses if Premium)',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const FormulaScholarBannerAd(margin: EdgeInsets.zero),
            const SizedBox(height: 24),

            // Premium Status Card
            _buildPremiumStatusCard(context),
            const SizedBox(height: 20),

            // Ad Density Switcher
            _buildDensitySwitcher(context),
            const SizedBox(height: 20),

            // Interactive Ad Trigger Tests
            _buildAdTriggers(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumStatusCard(BuildContext context) {
    return BlocBuilder<PremiumCubit, PremiumState>(
      builder: (context, state) {
        final isPremium = state.isPremium;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111726),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPremium ? const Color(0xFF10B981) : Colors.white12,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isPremium ? LucideIcons.shieldCheck : LucideIcons.shield,
                color: isPremium ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPremium ? 'Super Scholar Active (0 Ads)' : 'Free Tier Active (Ads Enabled)',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      isPremium ? 'Zero ads guaranteed across entire app' : 'Ads shown per density setting',
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isPremium,
                activeThumbColor: const Color(0xFF10B981),
                onChanged: (val) => context.read<PremiumCubit>().toggleMockPremium(val),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDensitySwitcher(BuildContext context) {
    return BlocBuilder<AdCubit, AdState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111726),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AD DENSITY CONFIGURATION',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...AdDensityLevel.values.map((density) {
                final isSelected = state.densityLevel == density;
                return InkWell(
                  onTap: () => context.read<AdCubit>().setDensityLevel(density),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? const Color(0xFF38BDF8) : Colors.white38,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                density.displayName,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Interval: ${density.actionIntervalCount} actions • Cooldown: ${density.cooldownSeconds}s',
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdTriggers(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111726),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INTERACTIVE AD WINDOW TESTS',
            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(LucideIcons.sparkles, size: 16),
            label: const Text('Test Duolingo Post-Quiz Window'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () {
              context.read<AdCubit>().triggerInterstitialAd(
                    AdPlacement.postQuizInterstitial,
                  );
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(LucideIcons.flame, size: 16),
            label: const Text('Test Rewarded Streak Freeze Revive'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () {
              context.read<AdCubit>().triggerRewardedAd(
                    placement: AdPlacement.streakReviveRewarded,
                    reward: const AdReward(
                      type: AdRewardType.streakFreeze,
                      amount: 1,
                      rewardId: 'streak_freeze_revive',
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
