library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../../../auth/auth.dart';

import '../cubit/saved_cubit.dart';

class SavedAppBar extends StatelessWidget {
  const SavedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.user != curr.user,
      builder: (context, authState) {
        return GlassAppBar(
          titleWidget: Text(
            context.l10n.navSaved,
            style: AppTextStyles.headlineSmall.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsetsDirectional.only(
                end: AppDimensions.paddingSM,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              ),
              child: IconButton(
                onPressed: () {
                  final curr = context.read<CurriculumCubit>().state.curriculum;
                  if (curr != null) {
                    context.read<SavedCubit>().loadBookmarks(
                      curriculumKey: curr.curriculumKey,
                    );
                  }
                },
                icon: Icon(LucideIcons.refreshCw, color: colorScheme.primary),
                tooltip: context.l10n.refreshBookmarks,
              ),
            ),
          ],
        );
      },
    );
  }
}
