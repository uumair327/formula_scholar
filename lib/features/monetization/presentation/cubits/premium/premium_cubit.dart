import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/constants/app_log_tags.dart';
import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/premium_plan.dart';
import '../../../domain/entities/user_entitlements.dart';
import '../../../domain/ports/premium_repository_port.dart';
import '../../../domain/usecases/get_user_entitlements_use_case.dart';
import '../../../domain/usecases/restore_purchases_use_case.dart';
import '../../../domain/usecases/upgrade_to_premium_use_case.dart';
import 'premium_state.dart';

@lazySingleton
class PremiumCubit extends Cubit<PremiumState> {
  PremiumCubit({
    required GetUserEntitlementsUseCase getUserEntitlements,
    required UpgradeToPremiumUseCase upgradeToPremium,
    required RestorePurchasesUseCase restorePurchases,
    required PremiumRepositoryPort premiumRepository,
  })  : _getUserEntitlements = getUserEntitlements,
        _upgradeToPremium = upgradeToPremium,
        _restorePurchases = restorePurchases,
        _premiumRepository = premiumRepository,
        super(const PremiumState()) {
    _init();
  }

  final GetUserEntitlementsUseCase _getUserEntitlements;
  final UpgradeToPremiumUseCase _upgradeToPremium;
  final RestorePurchasesUseCase _restorePurchases;
  final PremiumRepositoryPort _premiumRepository;

  StreamSubscription? _entitlementsSub;

  Future<void> _init() async {
    try {
      emit(state.copyWith(status: PremiumStatus.loading));
      final entitlements = await _getUserEntitlements();
      final plans = await _premiumRepository.getAvailablePlans();
      final defaultSelected = plans.firstWhere(
        (p) => p.isBestValue,
        orElse: () => plans.first,
      );

      emit(state.copyWith(
        status: PremiumStatus.ready,
        entitlements: entitlements,
        plans: plans,
        selectedPlan: defaultSelected,
      ));

      _entitlementsSub = _getUserEntitlements.watch().listen((updated) {
        emit(state.copyWith(entitlements: updated));
      });
    } catch (e, st) {
      AppLogger.error('Failed to initialize PremiumCubit',
          tag: AppLogTags.premiumCubit, error: e, stackTrace: st);
      emit(state.copyWith(status: PremiumStatus.error, errorMessage: e.toString()));
    }
  }

  void selectPlan(PremiumPlan plan) {
    emit(state.copyWith(selectedPlan: plan));
  }

  Future<bool> purchaseSelectedPlan() async {
    final plan = state.selectedPlan;
    if (plan == null) return false;

    try {
      emit(state.copyWith(status: PremiumStatus.purchasing));
      final updated = await _upgradeToPremium(plan);
      emit(state.copyWith(
        status: PremiumStatus.success,
        entitlements: updated,
      ));
      return true;
    } catch (e, st) {
      AppLogger.error('Purchase failed',
          tag: AppLogTags.premiumCubit, error: e, stackTrace: st);
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: 'Unable to complete purchase. Please try again.',
      ));
      return false;
    }
  }

  Future<bool> restoreUserPurchases() async {
    try {
      emit(state.copyWith(status: PremiumStatus.restoring));
      final restored = await _restorePurchases();
      emit(state.copyWith(
        status: PremiumStatus.success,
        entitlements: restored,
      ));
      return true;
    } catch (e, st) {
      AppLogger.error('Restore purchases failed',
          tag: AppLogTags.premiumCubit, error: e, stackTrace: st);
      emit(state.copyWith(
        status: PremiumStatus.error,
        errorMessage: 'Unable to restore purchases.',
      ));
      return false;
    }
  }

  /// Developer / QA toggle to simulate premium entitlement.
  Future<void> toggleMockPremium(bool enable) async {
    final newEntitlements = enable
        ? UserEntitlements(
            tier: state.plans.isNotEmpty
                ? state.plans.first.tier
                : UserEntitlements.free.tier,
            isLifetime: true,
            unlockedPerks: const ['0_ads', 'unlimited_hearts', 'ai_tutor', 'offline_3d'],
          )
        : UserEntitlements.free;

    await _premiumRepository.updateEntitlements(newEntitlements);
    emit(state.copyWith(entitlements: newEntitlements));
  }

  @override
  Future<void> close() {
    _entitlementsSub?.cancel();
    return super.close();
  }
}
