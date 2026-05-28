library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubit/curriculum_options_cubit.dart';

class CurriculumErrorRow extends StatelessWidget {
  const CurriculumErrorRow({super.key, this.errorMessage, this.errorKey});

  final String? errorMessage;
  final String? errorKey;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingSM),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.localizedError(
                errorKey: errorKey,
                fallback:
                    errorMessage ??
                    context.l10n.dashboardCurriculumOptionsLoadFailed,
              ),
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.error,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () =>
                context.read<CurriculumOptionsCubit>().loadOptions(),
            child: Text(context.l10n.dashboardRetryCurriculumOptions),
          ),
        ],
      ),
    );
  }
}
