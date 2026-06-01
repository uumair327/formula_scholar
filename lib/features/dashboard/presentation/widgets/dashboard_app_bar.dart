library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        final user = authState.user;
        final userName = user?.displayName ?? l10n.dashboardSanctuary;

        return SliverGlassAppBar(
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userName,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                l10n.welcomeBack,
                style: AppTextStyles.overline.copyWith(
                  color: colorScheme.primary,
                  fontSize: AppDimensions.fontSizeXS,
                ),
              ),
            ],
          ),
          bottom: const DummySearchPill(),
        );
      },
    );
  }
}
