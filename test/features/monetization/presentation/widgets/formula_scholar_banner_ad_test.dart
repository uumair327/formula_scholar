import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_config.dart';
import 'package:formula_scholar/features/monetization/domain/entities/ad_density_level.dart';
import 'package:formula_scholar/features/monetization/domain/entities/premium_tier.dart';
import 'package:formula_scholar/features/monetization/domain/entities/user_entitlements.dart';
import 'package:formula_scholar/features/monetization/domain/ports/ad_repository_port.dart';
import 'package:formula_scholar/features/monetization/domain/ports/ad_service_port.dart';
import 'package:formula_scholar/features/monetization/domain/ports/premium_repository_port.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/ad/ad_cubit.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/ad/ad_state.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/premium/premium_cubit.dart';
import 'package:formula_scholar/features/monetization/presentation/cubits/premium/premium_state.dart';
import 'package:formula_scholar/features/monetization/presentation/widgets/formula_scholar_banner_ad.dart';

class MockAdCubit extends Cubit<AdState> implements AdCubit {
  MockAdCubit(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockPremiumCubit extends Cubit<PremiumState> implements PremiumCubit {
  MockPremiumCubit(super.initialState);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('FormulaScholarBannerAd Widget Tests - Zero Ad Policy', () {
    testWidgets('Renders banner when user is Free and standard density is enabled', (tester) async {
      final adCubit = MockAdCubit(const AdState(
        config: AdConfig(densityLevel: AdDensityLevel.standard),
      ));
      final premiumCubit = MockPremiumCubit(const PremiumState(
        entitlements: UserEntitlements.free,
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AdCubit>.value(value: adCubit),
              BlocProvider<PremiumCubit>.value(value: premiumCubit),
            ],
            child: const Scaffold(
              body: FormulaScholarBannerAd(),
            ),
          ),
        ),
      );

      expect(find.text('FORMULA SCHOLAR FREE'), findsOneWidget);
      expect(find.text('GO SUPER 💎'), findsOneWidget);
    });

    testWidgets('Completely collapses (SizedBox.shrink) when user is Premium (Zero-Ad guarantee)', (tester) async {
      final adCubit = MockAdCubit(const AdState(
        config: AdConfig(densityLevel: AdDensityLevel.standard),
      ));
      final premiumCubit = MockPremiumCubit(const PremiumState(
        entitlements: UserEntitlements(tier: PremiumTier.scholarPlus, isLifetime: true),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AdCubit>.value(value: adCubit),
              BlocProvider<PremiumCubit>.value(value: premiumCubit),
            ],
            child: const Scaffold(
              body: FormulaScholarBannerAd(),
            ),
          ),
        ),
      );

      expect(find.text('FORMULA SCHOLAR FREE'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
