import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import 'package:go_router/go_router.dart';
import '../../domain/domain.dart';
import '../../../profile/presentation/widgets/support_contact_sheet.dart';

class MasteryToolsSection extends StatelessWidget {
  const MasteryToolsSection({super.key, required this.tools});

  final List<MasteryTool> tools;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionTitle(
          title: AppStrings.masteryTools,
          leadingIcon: LucideIcons.sparkles,
        ),
        const SizedBox(height: AppDimensions.paddingLG),
        if (tools.isEmpty)
          AppCard(
            color: AppColors.white,
            boxShadow: const [AppShadows.subtle],
            child: Row(
              children: [
                const Icon(
                  LucideIcons.info,
                  color: AppColors.primary,
                  size: AppDimensions.iconLG,
                ),
                const SizedBox(width: AppDimensions.paddingMD),
                Expanded(
                  child: Text(
                    AppStrings.masteryToolsSyncing,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppDimensions.masteryToolsCrossAxisCount,
              mainAxisSpacing: AppDimensions.masteryToolsSpacing,
              crossAxisSpacing: AppDimensions.masteryToolsSpacing,
              childAspectRatio: AppDimensions.masteryToolsAspectRatio,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              final icon = _iconFor(tool.iconName);
              final color = _colorFor(tool.iconName);
              return GestureDetector(
                onTap: () {
                  if (tool.isEnabled &&
                      _navigateForRoute(context, tool.routeName)) {
                    return;
                  }

                  {
                    // Provide support contact flow for unimplemented mastery tools
                    final subtitle = _getToolSubtitle(tool);
                    SupportContactSheet.show(
                      context,
                      title: tool.label,
                      subtitle: subtitle,
                      email: 'support@formulascholar.app',
                    );
                  }
                },
                child: AppCard(
                  color: AppColors.white,
                  boxShadow: const [AppShadows.subtle],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, size: AppDimensions.iconXXL, color: color),
                      const SizedBox(height: AppDimensions.paddingSM),
                      Text(
                        tool.label,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  /// Returns context-specific subtitle for each mastery tool.
  String _getToolSubtitle(MasteryTool tool) {
    if (tool.supportSubtitle != null && tool.supportSubtitle!.isNotEmpty) {
      return tool.supportSubtitle!;
    }

    if (tool.label == AppStrings.videoLessons) {
      return 'Video Lessons are currently being prepared. Contact support if you need access to guided tutorial content.';
    } else if (tool.label == AppStrings.cheatSheets) {
      return 'Cheat Sheets provide quick formula reference guides. Contact support to request this feature for your curriculum.';
    } else if (tool.label == AppStrings.visualizer3d) {
      return '3D Visualizer helps understand geometric concepts. Contact support to request 3D visualization tools.';
    }
    return 'This feature is not yet available. Contact support for more information.';
  }

  /// Routes to a known shell branch for backend-provided route names.
  bool _navigateForRoute(BuildContext context, String? routeName) {
    if (routeName == null || routeName.isEmpty) {
      return false;
    }

    final shell = StatefulNavigationShell.of(context);
    switch (routeName) {
      case 'dashboard':
        shell.goBranch(0);
        return true;
      case 'chapters':
        shell.goBranch(1);
        return true;
      case 'practice':
        shell.goBranch(2);
        return true;
      case 'saved':
        shell.goBranch(3);
        return true;
      default:
        return false;
    }
  }

  IconData _iconFor(String iconName) {
    switch (iconName) {
      case 'graduationCap':
        return LucideIcons.graduationCap;
      case 'helpCircle':
        return LucideIcons.helpCircle;
      case 'fileText':
        return LucideIcons.fileText;
      case 'box':
        return LucideIcons.box;
      default:
        return LucideIcons.sparkles;
    }
  }

  Color _colorFor(String iconName) {
    switch (iconName) {
      case 'graduationCap':
        return AppColors.primary;
      case 'helpCircle':
        return AppColors.secondary;
      case 'fileText':
        return AppColors.orange500;
      case 'box':
        return AppColors.tertiary;
      default:
        return AppColors.primary;
    }
  }
}
