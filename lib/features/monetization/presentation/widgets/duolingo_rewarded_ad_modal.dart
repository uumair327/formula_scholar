import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entities/ad_placement.dart';
import '../../domain/entities/ad_reward.dart';
import '../../domain/ports/ad_service_port.dart';

/// Fullscreen Duolingo-style rewarded ad celebration modal.
class DuolingoRewardedAdModal extends StatefulWidget {
  const DuolingoRewardedAdModal({
    super.key,
    required this.placement,
    required this.reward,
  });

  final AdPlacement placement;
  final AdReward reward;

  @override
  State<DuolingoRewardedAdModal> createState() =>
      _DuolingoRewardedAdModalState();
}

class _DuolingoRewardedAdModalState extends State<DuolingoRewardedAdModal>
    with SingleTickerProviderStateMixin {
  int _secondsLeft = 6;
  Timer? _timer;
  late final AnimationController _bounceController;
  bool _rewardClaimed = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        _timer?.cancel();
        setState(() => _rewardClaimed = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  void _claimAndClose() {
    Navigator.of(context).pop(
      AdShowResult(
        status: AdShowStatus.completed,
        reward: widget.reward,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rewardEmoji = switch (widget.reward.type) {
      AdRewardType.streakFreeze => '🧊',
      AdRewardType.doubleXp => '⚡',
      AdRewardType.aiDerivation => '🧠',
      AdRewardType.formulaHint => '💡',
    };

    final rewardTitle = switch (widget.reward.type) {
      AdRewardType.streakFreeze => 'Streak Freeze Restored!',
      AdRewardType.doubleXp => 'Double XP Multiplier Unlocked!',
      AdRewardType.aiDerivation => 'AI Deep Derivation Unlocked!',
      AdRewardType.formulaHint => 'Formula Hint Ready!',
    };

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF0B132B),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
              ),
              child: Text(
                _rewardClaimed ? 'REWARD READY! 🎉' : 'WATCHING SPONSOR ($_secondsLeft s)',
                style: const TextStyle(
                  color: Color(0xFFFBBF24),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Animated Trophy / Reward Emoji
            ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1.15).animate(
                CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
              ),
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(rewardEmoji, style: const TextStyle(fontSize: 44)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              rewardTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              widget.reward.label ??
                  'Thanks for supporting free STEM education! Your reward is active.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 24),

            // Claim Reward CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _rewardClaimed ? _claimAndClose : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF1E1B4B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 6,
                ),
                child: Text(
                  _rewardClaimed ? 'CLAIM REWARD & CONTINUE' : 'Reward unlocks in $_secondsLeft s',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
