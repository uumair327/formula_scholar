import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../../../../core/core.dart';
import '../../../../shared/shared.dart';
import '../../../auth/auth.dart';
import '../cubit/saved_cubit.dart';
import '../cubit/saved_state.dart';
import '../../domain/domain.dart';

/// Saved/Bookmarks page matching the React prototype.
class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    super.initState();
    context.read<SavedCubit>().loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      builder: (context, state) {
        if (state.status == SavedStatus.loading ||
            state.status == SavedStatus.initial) {
          return const Scaffold(body: AppLoadingState());
        }

        if (state.status == SavedStatus.error) {
          return Scaffold(
            body: AppErrorState(
              message: state.errorMessage,
              onRetry: () => context.read<SavedCubit>().loadBookmarks(),
            ),
          );
        }

        if (state.isEmpty) {
          // Show empty bookmarks state (matching prototype).
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppDimensions.paddingXXL,
                  right: AppDimensions.paddingXXL,
                  top: AppDimensions.paddingXXL,
                  bottom: AppDimensions.bottomNavPadding,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildEmptyState(context),
                    const SizedBox(height: AppDimensions.paddingSection),
                    _buildProTipBanner(),
                  ],
                ),
              ),
            ),
          );
        }

        // Show loaded bookmarks
        return Scaffold(
          appBar: _buildAppBar(context),
          body: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingXXL),
            itemCount: state.bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.paddingLG),
            itemBuilder: (context, index) {
              final bookmark = state.bookmarks[index];
              return _BookmarkCard(bookmark: bookmark);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSectionLG),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Column(
        children: [
          // Bookmark icon with plus badge.
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppDimensions.imageXL,
                height: AppDimensions.imageXL,
                decoration: const BoxDecoration(
                  color: AppColors.tertiaryFixed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.bookmark,
                  size: AppDimensions.imageLG,
                  color: AppColors.onTertiaryContainer,
                ),
              ),
              Positioned(
                bottom: AppDimensions.positionOffsetSM,
                right: AppDimensions.positionOffsetSM,
                child: Container(
                  width: AppDimensions.imageMD,
                  height: AppDimensions.imageMD,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    shape: BoxShape.circle,
                    boxShadow: const [AppShadows.ghost],
                  ),
                  child: const Icon(
                    LucideIcons.plus,
                    size: AppDimensions.iconLG,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            AppStrings.nothingHereYet,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            AppStrings.emptyBookmarksDesc,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXXL),
          // Browse Lessons button.
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.compass),
            label: const Text(AppStrings.browseLessons),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryContainer,
              foregroundColor: AppColors.onSecondaryContainer,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXXL,
                vertical: AppDimensions.paddingMD,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXXL),
              ),
              elevation: AppDimensions.elevationNone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTipBanner() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXXL),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(
          alpha: AppDimensions.opacitySubtle,
        ),
        border: Border.all(
          color: AppColors.tertiaryContainer.withValues(
            alpha: AppDimensions.opacityLight,
          ),
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            LucideIcons.lightbulb,
            size: AppDimensions.iconLG,
            color: AppColors.onTertiaryContainer,
          ),
          const SizedBox(width: AppDimensions.paddingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.proTip,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  AppStrings.proTipContent,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onTertiaryContainer,
                    height: AppDimensions.lineHeightDefault,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final authRepo = getIt<AuthRepositoryPort>();
    final user = authRepo.currentUser;
    final photoUrl = user?.photoUrl ?? '';

    return AppBar(
      backgroundColor: AppColors.surfaceContainerLowest.withValues(
        alpha: AppDimensions.opacityAppBar,
      ),
      surfaceTintColor: AppColors.transparent,
      title: Row(
        children: [
          if (photoUrl.isNotEmpty)
            AppAvatar(
              imageUrl: photoUrl,
              size: AppDimensions.avatarMD,
              fallbackIcon: LucideIcons.bookmark,
              fallbackIconColor: AppColors.primary,
            )
          else
            Container(
              width: AppDimensions.avatarMD,
              height: AppDimensions.avatarMD,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryFixed,
              ),
              child: const Icon(LucideIcons.bookmark, color: AppColors.primary),
            ),
          const SizedBox(width: AppDimensions.paddingMD),
          Text(
            AppStrings.navSaved,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () => context.read<SavedCubit>().loadBookmarks(),
          icon: const Icon(LucideIcons.refreshCw, color: AppColors.outline),
        ),
        const SizedBox(width: AppDimensions.paddingSM),
      ],
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final BookmarkedFormula bookmark;

  const _BookmarkCard({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookmark.subject,
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'SAVED ${_formatDate(bookmark.savedAt)}',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => context.read<SavedCubit>().removeBookmark(bookmark.id),
                icon: const Icon(
                  Icons.bookmark,
                  size: AppDimensions.iconMD,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingMD),
          Text(
            bookmark.title,
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingLG),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingLG),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Center(
              child: Math.tex(
                bookmark.formula,
                textStyle: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
