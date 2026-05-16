import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';
import '../cubit/formulas_cubit.dart';

/// Bottom sheet for viewing and editing a note attached to a formula.
class FormulaNoteSheet extends StatefulWidget {
  const FormulaNoteSheet({
    super.key,
    required this.formulaId,
    required this.formulaTitle,
  });

  final String formulaId;
  final String formulaTitle;

  @override
  State<FormulaNoteSheet> createState() => _FormulaNoteSheetState();
}

class _FormulaNoteSheetState extends State<FormulaNoteSheet> {
  late final TextEditingController _controller;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    final note = context.read<FormulasCubit>().state.noteFor(widget.formulaId);
    if (note != null) _controller.text = note.content;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _saving = true);
    context.read<FormulasCubit>().saveFormulaNote(FormulaNote(
      formulaId: widget.formulaId,
      content: content,
      updatedAt: DateTime.now(),
    ));
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _saving = false);
  }

  void _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete note?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<FormulasCubit>().deleteFormulaNote(widget.formulaId);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final existing = context.watch<FormulasCubit>().state.noteFor(widget.formulaId);
    final hasNote = existing != null && !existing.isEmpty;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppDimensions.paddingXXL,
        right: AppDimensions.paddingXXL,
        top: AppDimensions.paddingXXL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 32, height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Text('Notes', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.paddingXXS),
          Text(
            widget.formulaTitle,
            style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            decoration: InputDecoration(
              hintText: hasNote ? 'Edit your note...' : 'Write a note about this formula...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMD)),
              contentPadding: const EdgeInsets.all(AppDimensions.paddingMD),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (hasNote)
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(LucideIcons.trash2, size: 16),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(foregroundColor: colorScheme.error),
                ),
              const SizedBox(width: AppDimensions.paddingSM),
              FilledButton.icon(
                onPressed: _controller.text.trim().isEmpty ? null : _save,
                icon: _saving
                    ? SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary),
                      )
                    : const Icon(LucideIcons.save, size: 16),
                label: Text(hasNote ? 'Update' : 'Save'),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + AppDimensions.paddingMD),
        ],
      ),
    );
  }
}
