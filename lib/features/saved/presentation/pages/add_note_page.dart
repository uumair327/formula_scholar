import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';
import '../cubit/saved_cubit.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({
    super.key,
    this.existingNote,
    this.subject,
    this.subjectId,
    this.chapterId,
    this.formulaId,
    this.formulaTitle,
    this.formulaLatex,
  });

  final SavedNote? existingNote;
  final String? subject;
  final String? subjectId;
  final String? chapterId;
  final String? formulaId;
  final String? formulaTitle;
  final String? formulaLatex;

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  bool get _isEditing => widget.existingNote != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSaving = context.select<SavedCubit, bool>(
      (cubit) => cubit.state.isSavingNote,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? AppStrings.editNote : AppStrings.addNote),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _saveNote,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        child: Column(
          children: [
            if (widget.formulaTitle != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.paddingSM),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                ),
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.fileText,
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Expanded(
                      child: Text(
                        widget.formulaTitle!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: AppStrings.noteTitleHint,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: AppStrings.noteHint,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty || content.isEmpty) return;

    final cubit = context.read<SavedCubit>();
    final curriculum = context.read<CurriculumCubit>().state.curriculum;

    if (_isEditing) {
      await cubit.editNote(
        widget.existingNote!.copyWith(title: title, content: content),
      );
    } else {
      await cubit.addNote(
        title: title,
        content: content,
        subject: widget.subject ?? AppStrings.genericError,
        curriculumKey:
            curriculum?.curriculumKey ?? AppStrings.unknownCurriculum,
        subjectId: widget.subjectId,
        chapterId: widget.chapterId,
        formulaId: widget.formulaId,
        formulaTitle: widget.formulaTitle,
        formulaLatex: widget.formulaLatex,
      );
    }

    if (mounted) Navigator.of(context).pop();
  }
}
