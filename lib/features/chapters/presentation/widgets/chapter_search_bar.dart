library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';

import '../cubit/chapters_cubit.dart';

class ChapterSearchBar extends StatefulWidget {
  const ChapterSearchBar({super.key});

  @override
  State<ChapterSearchBar> createState() => _ChapterSearchBarState();
}

class _ChapterSearchBarState extends State<ChapterSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<ChaptersCubit>().state.searchQuery;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppDurations.debounceDefault, () {
      if (!mounted) return;
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
    });
  }

  void _clearSearch() {
    _controller.clear();
    _onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: EdgeInsets.zero,
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          return TextField(
            controller: _controller,
            onChanged: (val) {
              setState(() {});
              _onSearch(val);
            },
            decoration: InputDecoration(
              hintText: context.l10n.searchChaptersHint,
              prefixIcon: const Icon(LucideIcons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        LucideIcons.x,
                        size: AppDimensions.iconSM,
                      ),
                      onPressed: _clearSearch,
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colorScheme.surface,
            ),
          );
        },
      ),
    );
  }
}
