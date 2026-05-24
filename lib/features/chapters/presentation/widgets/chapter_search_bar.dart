library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../cubit/chapters_cubit.dart';

class ChapterSearchBar extends StatefulWidget {
  const ChapterSearchBar({super.key});

  @override
  State<ChapterSearchBar> createState() => _ChapterSearchBarState();
}

class _ChapterSearchBarState extends State<ChapterSearchBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: TextField(
        onChanged: (value) {
          _debounce?.cancel();
          _debounce = Timer(
            AppDurations.debounceDefault,
            () {
              if (!context.mounted) return;
              final curriculumKey = context
                  .read<CurriculumCubit>()
                  .state
                  .curriculum
                  ?.curriculumKey;
              final subjectId = context
                  .read<SubjectSelectionCubit>()
                  .state
                  .subject
                  ?.id;
              if (subjectId == null ||
                  curriculumKey == null ||
                  curriculumKey.isEmpty) {
                return;
              }
              final cubitState = context.read<ChaptersCubit>().state;
              unawaited(
                context.read<ChaptersCubit>().loadChapters(
                  subjectId,
                  curriculumKey: curriculumKey,
                  searchQuery: value,
                  sortBy: cubitState.sortBy,
                  sortDesc: cubitState.sortDesc,
                ),
              );
            },
          );
        },
        decoration: InputDecoration(
          hintText: AppStrings.searchChaptersHint,
          prefixIcon: const Icon(LucideIcons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusLG,
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: colorScheme.surface,
        ),
      ),
    );
  }
}
