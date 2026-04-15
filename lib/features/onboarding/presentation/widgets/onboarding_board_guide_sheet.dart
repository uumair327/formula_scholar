import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../domain/domain.dart';

/// Bottom sheet that explains available boards and lets the user pick one.
class OnboardingBoardGuideSheet extends StatelessWidget {
  final List<Board> boards;
  final String? selectedBoardId;
  final ValueChanged<Board> onSelectBoard;

  const OnboardingBoardGuideSheet({
    super.key,
    required this.boards,
    required this.selectedBoardId,
    required this.onSelectBoard,
  });

  static void show(
    BuildContext context, {
    required List<Board> boards,
    required String? selectedBoardId,
    required ValueChanged<Board> onSelectBoard,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => OnboardingBoardGuideSheet(
        boards: boards,
        selectedBoardId: selectedBoardId,
        onSelectBoard: onSelectBoard,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXXL),
          topRight: Radius.circular(AppDimensions.radiusXXL),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXXL,
            vertical: AppDimensions.paddingLG,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: AppDimensions.avatarMD,
                  height: AppDimensions.borderWidthThick,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusXXL,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              Row(
                children: [
                  AppIconCircle(
                    icon: LucideIcons.info,
                    size: AppDimensions.avatarHero,
                    backgroundColor: AppColors.primaryFixed,
                    iconColor: AppColors.primary,
                    iconSize: AppDimensions.iconXL,
                  ),
                  const SizedBox(width: AppDimensions.paddingLG),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.step2LearnMore,
                          style: AppTextStyles.headlineSmall.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingXXS),
                        Text(
                          'Choose the board that matches your school curriculum. '
                          'You can change this later from onboarding.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingXXL),
              if (boards.isEmpty)
                AppCard(
                  child: Text(
                    'No boards are available for the selected region yet.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                )
              else
                Column(
                  children: boards
                      .map(
                        (board) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppDimensions.paddingMD,
                          ),
                          child: _BoardGuideCard(
                            board: board,
                            isSelected: board.id == selectedBoardId,
                            onTap: () {
                              onSelectBoard(board);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: AppDimensions.paddingLG),
              Text(
                'Tip: national boards are ideal when your school follows a country-wide syllabus, while state boards are best when your school uses a regional curriculum.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMD),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardGuideCard extends StatelessWidget {
  final Board board;
  final bool isSelected;
  final VoidCallback onTap;

  const _BoardGuideCard({
    required this.board,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(board.type);
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        child: AppCard(
          color: isSelected
              ? accent.withValues(alpha: AppDimensions.opacityLight)
              : AppColors.surfaceContainerLowest,
          border: Border.all(
            color: isSelected ? accent : AppColors.surfaceContainerHigh,
          ),
          child: Row(
            children: [
              AppIconCircle(
                icon: _iconForType(board.type),
                backgroundColor: accent.withValues(
                  alpha: AppDimensions.opacityFaint,
                ),
                iconColor: accent,
              ),
              const SizedBox(width: AppDimensions.paddingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      board.name,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXXS),
                    Text(
                      board.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      _boardHint(board.type),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.paddingMD),
              Icon(
                isSelected
                    ? LucideIcons.checkCircle2
                    : LucideIcons.chevronRight,
                color: isSelected ? accent : AppColors.outlineVariant,
                size: AppDimensions.iconMD,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(BoardType type) {
    return switch (type) {
      BoardType.state => LucideIcons.school,
      BoardType.national => LucideIcons.landmark,
      BoardType.private => LucideIcons.globe,
      BoardType.examination => LucideIcons.bookOpen,
    };
  }

  Color _accentColor(BoardType type) {
    return switch (type) {
      BoardType.state => const Color(0xFF00639A),
      BoardType.national => const Color(0xFF00639A),
      BoardType.private => const Color(0xFF056C42),
      BoardType.examination => const Color(0xFF655781),
    };
  }

  String _boardHint(BoardType type) {
    return switch (type) {
      BoardType.state => 'Best for region-specific syllabi',
      BoardType.national => 'Best for country-wide syllabi',
      BoardType.private => 'Best for private/international schools',
      BoardType.examination => 'Best for exam-focused curricula',
    };
  }
}
