import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/entities/premium_plan.dart';
import '../cubits/premium/premium_cubit.dart';
import '../cubits/premium/premium_state.dart';

/// Full-fidelity Duolingo Super style subscription paywall modal.
class PremiumPaywallSheet extends StatelessWidget {
  const PremiumPaywallSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumCubit, PremiumState>(
      builder: (context, state) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF090D16),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    children: [
                      // Cosmic Diamond Header
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // Key Perks List
                      _buildPerksList(),
                      const SizedBox(height: 24),

                      // Plan Cards
                      if (state.plans.isNotEmpty)
                        ...state.plans.map((plan) {
                          final isSelected = state.selectedPlan?.id == plan.id;
                          return _buildPlanCard(context, plan, isSelected);
                        }),

                      const SizedBox(height: 24),

                      // Main Action CTA
                      _buildActionButton(context, state),
                      const SizedBox(height: 12),

                      // Restore Purchases
                      TextButton(
                        onPressed: () => context.read<PremiumCubit>().restoreUserPurchases(),
                        child: const Text(
                          'Restore Previous Purchases',
                          style: TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                blurRadius: 32,
              ),
            ],
          ),
          child: const Center(
            child: Text('💎', style: TextStyle(fontSize: 38)),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Super Formula Scholar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Supercharge your STEM recall with zero ads & unlimited power.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPerksList() {
    final perks = [
      ('🚫', '100% Zero Advertisements', 'Pure uninterrupted study focus'),
      ('⚡', 'Unlimited Quiz Attempts', 'Practice until formulas become second nature'),
      ('🧠', 'Step-by-Step AI Proofs', 'Ask Sigma AI for deep formula derivations'),
      ('🧊', 'Daily Streak Protection', 'Never lose your hard-earned study habit'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111726),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: perks.map((p) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Text(p.$1, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.$2,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        p.$3,
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.check, color: Color(0xFF10B981), size: 18),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, PremiumPlan plan, bool isSelected) {
    return GestureDetector(
      onTap: () => context.read<PremiumCubit>().selectPlan(plan),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF111726),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF8B5CF6) : Colors.white10,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.white38,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        plan.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (plan.badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            plan.badgeText!,
                            style: const TextStyle(
                              color: Color(0xFFA78BFA),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.hasTrial ? 'Includes 7-day free trial' : 'Billed ${plan.interval.name}',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              plan.priceFormatted,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, PremiumState state) {
    final plan = state.selectedPlan;
    final isPurchasing = state.status == PremiumStatus.purchasing;
    final label = plan?.hasTrial == true
        ? 'START 7-DAY FREE TRIAL'
        : 'UPGRADE TO SUPER SCHOLAR';

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isPurchasing
            ? null
            : () async {
                final success = await context.read<PremiumCubit>().purchaseSelectedPlan();
                if (success && context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Welcome to Super Scholar! 0 Ads are active.'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
        ),
        child: isPurchasing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
      ),
    );
  }
}
