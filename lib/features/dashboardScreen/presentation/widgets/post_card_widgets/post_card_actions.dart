import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_state.dart';

class PostCardActions extends StatelessWidget {
  final PostEntity post;

  const PostCardActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildActionButton(
          context,
          icon: Icons.favorite_border,
          activeIcon: Icons.favorite,
          label: '${post.likes.length}',
          isActive: post.likes.isNotEmpty, // TODO: Check if current user liked
          onTap: () => _handleLike(context),
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context,
          icon: Icons.comment_outlined,
          label: '${post.comments.length}',
          onTap: () => _handleComment(context),
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          context,
          icon: Icons.share_outlined,
          label: 'Share',
          onTap: () => _handleShare(context),
        ),
        const Spacer(),
        _buildActionButton(
          context,
          icon: Icons.bookmark_border,
          onTap: () => _handleBookmark(context),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    IconData? activeIcon,
    String? label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return BlocBuilder<LikePostBloc, LikePostState>(
      builder: (context, state) {
        final isLoading = state is LikePostLoading;

        return InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        SkillWaveAppColors.primary,
                      ),
                    ),
                  )
                else
                  Icon(
                    isActive ? (activeIcon ?? icon) : icon,
                    size: 20,
                    color: isActive
                        ? SkillWaveAppColors.red
                        : SkillWaveAppColors.textSecondary,
                  ),
                if (label != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: SkillWaveAppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLike(BuildContext context) {
    context.read<LikePostBloc>().add(LikePost(post.id));
  }

  void _handleComment(BuildContext context) {
    // TODO: Show comment input
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment functionality coming soon!')),
    );
  }

  void _handleShare(BuildContext context) {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon!')),
    );
  }

  void _handleBookmark(BuildContext context) {
    // TODO: Implement bookmark functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmark functionality coming soon!')),
    );
  }
}
