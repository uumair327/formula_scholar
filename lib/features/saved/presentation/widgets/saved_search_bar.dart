library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/core.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';

class SavedSearchBar extends StatefulWidget {
  const SavedSearchBar({super.key});

  @override
  State<SavedSearchBar> createState() => _SavedSearchBarState();
}

class _SavedSearchBarState extends State<SavedSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      buildWhen: (p, n) =>
          p.searchQuery != n.searchQuery || p.isEmpty != n.isEmpty,
      builder: (context, state) {
        if (state.isEmpty) {
          return const SizedBox.shrink();
        }

        if (_searchController.text != state.searchQuery) {
          _searchController.value = _searchController.value.copyWith(
            text: state.searchQuery,
            selection: TextSelection.collapsed(
              offset: state.searchQuery.length,
            ),
            composing: TextRange.empty,
          );
        }

        return TextField(
          controller: _searchController,
          onChanged: (value) {
            _searchDebounce?.cancel();
            _searchDebounce = Timer(
              AppDurations.debounceDefault,
              () => context.read<SavedCubit>().updateSearchQuery(value),
            );
          },
          decoration: InputDecoration(
            hintText: AppStrings.searchBookmarks,
            prefixIcon: const Icon(LucideIcons.search),
            suffixIcon: state.searchQuery.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      _searchController.clear();
                      context.read<SavedCubit>().updateSearchQuery('');
                    },
                    icon: const Icon(LucideIcons.x),
                    tooltip: AppStrings.clearSearch,
                  ),
          ),
        );
      },
    );
  }
}
