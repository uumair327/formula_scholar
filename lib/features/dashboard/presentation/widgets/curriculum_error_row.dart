library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../cubit/curriculum_options_cubit.dart';

class CurriculumErrorRow extends StatelessWidget {
  const CurriculumErrorRow({super.key, this.errorMessage});

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.paddingSM),
      child: Row(
        children: [
          Expanded(
            child: Text(
              errorMessage ?? AppStrings.dashboardCurriculumOptionsLoadFailed,
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.read<CurriculumOptionsCubit>().loadOptions(),
            child: const Text(AppStrings.dashboardRetryCurriculumOptions),
          ),
        ],
      ),
    );
  }
}
