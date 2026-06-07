library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../pages/vault_quick_revision_page.dart';

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
            // Quick Revision Button
            BlocBuilder<SavedCubit, SavedState>(
              builder: (context, state) {
                final hasFormulas = state.bookmarks.isNotEmpty;
                return Container(
                  margin: const EdgeInsetsDirectional.only(
                    end: AppDimensions.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    color: hasFormulas
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (!hasFormulas) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.quickRevisionEmpty),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VaultQuickRevisionPage(
                            formulas: state.bookmarks,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      LucideIcons.play,
                      color: hasFormulas
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    tooltip: context.l10n.quickRevisionTitle,
                  ),
                );
              },
            ),
            // Share Button
            BlocBuilder<SavedCubit, SavedState>(
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsetsDirectional.only(
                    end: AppDimensions.paddingSM,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
                  ),
                  child: IconButton(
                    onPressed: () => _shareVault(context, state),
                    icon: Icon(Icons.share, color: colorScheme.primary),
                    tooltip: context.l10n.shareVault,
                  ),
                );
              },
            ),
            // Refresh Button
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

  void _shareVault(BuildContext context, SavedState state) {
    if (state.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln(context.l10n.vaultSummaryTitle);
    buffer.writeln('=' * 20);
    buffer.writeln();

    if (state.bookmarks.isNotEmpty) {
      buffer.writeln('${context.l10n.vaultStatsFormulas} (${state.bookmarks.length}):');
      final bySubject = <String, List<String>>{};
      for (final b in state.bookmarks) {
        bySubject.putIfAbsent(b.subject, () => []).add(b.title);
      }
      
      for (final entry in bySubject.entries) {
        buffer.writeln('  [${entry.key}]');
        for (final title in entry.value) {
          buffer.writeln('  - $title');
        }
        buffer.writeln();
      }
    }

    if (state.chapters.isNotEmpty) {
      buffer.writeln('${context.l10n.vaultStatsChapters} (${state.chapters.length}):');
      for (final c in state.chapters) {
        buffer.writeln('  - ${c.chapterName} (${c.subjectName})');
      }
      buffer.writeln();
    }

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.l10n.vaultCopiedToClipboard),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
