import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../domain/domain.dart';

class StreakCalendar extends StatelessWidget {
  const StreakCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.history,
    required this.onPrevious,
    required this.onNext,
    this.joinDate,
    this.canGoPrevious = true,
  });

  final int year;
  final int month;
  final StreakHistoryMonth? history;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final DateTime? joinDate;
  final bool canGoPrevious;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final date = DateTime(year, month);
    final monthName = DateFormat('MMMM yyyy').format(date);
    
    // Calculate calendar grid
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    // weekday is 1 (Mon) to 7 (Sun). We want 0 (Sun) to 6 (Sat)
    final firstDayOffset = date.weekday % 7; 
    
    final totalCells = daysInMonth + firstDayOffset;
    final rows = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLG),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  LucideIcons.chevronLeft,
                  color: canGoPrevious ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                onPressed: canGoPrevious ? onPrevious : null,
              ),
              Text(
                monthName,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(LucideIcons.chevronRight),
                onPressed: onNext,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          
          // Day labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((day) => Text(
                      day,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows * 7,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final day = index - firstDayOffset + 1;
              
              if (day < 1 || day > daysInMonth) {
                return const SizedBox.shrink();
              }
              
              final isActive = history?.activeDays.contains(day) ?? false;
              final isFreeze = history?.freezeDays.contains(day) ?? false;
              final isJoinDate = joinDate != null && 
                  joinDate!.year == year && 
                  joinDate!.month == month && 
                  joinDate!.day == day;
              
              return _DayCell(
                day: day,
                isActive: isActive,
                isFreeze: isFreeze,
                isJoinDate: isJoinDate,
                colorScheme: colorScheme,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isActive,
    required this.isFreeze,
    this.isJoinDate = false,
    required this.colorScheme,
  });

  final int day;
  final bool isActive;
  final bool isFreeze;
  final bool isJoinDate;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = colorScheme.onSurface;
    
    if (isActive) {
      bgColor = Colors.orangeAccent;
      textColor = Colors.white;
    } else if (isFreeze) {
      bgColor = Colors.lightBlueAccent;
      textColor = Colors.white;
    } else if (isJoinDate) {
      bgColor = Colors.redAccent.withValues(alpha: 0.1);
      textColor = Colors.redAccent;
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: isJoinDate && !isActive
            ? Border.all(color: Colors.redAccent, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(
            day.toString(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: textColor,
              fontWeight: isActive || isFreeze ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            const Positioned(
              bottom: -4,
              child: Icon(
                LucideIcons.flame,
                size: 12,
                color: Colors.white,
              ),
            )
          else if (isFreeze)
            const Positioned(
              bottom: -4,
              child: Icon(
                Icons.ac_unit_rounded,
                size: 12,
                color: Colors.white,
              ),
            )
          else if (isJoinDate)
            const Positioned(
              bottom: -8,
              child: Icon(
                LucideIcons.sparkles,
                size: 12,
                color: Colors.redAccent,
              ),
            ),
        ],
      ),
    );
  }
}
