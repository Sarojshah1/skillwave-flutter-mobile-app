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
    return BlocBuilder<LikePostBloc, LikePostState>(
      builder: (context, state) {
        final isLoading = state is LikePostLoading;
        final isLiked =
            post.likes.isNotEmpty; // TODO: Check if current user liked

        return Column(
          children: [
            // Action buttons grid
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    label: 'Like',
                    isActive: isLiked,
                    isLoading: isLoading,
                    onTap: () => _handleLike(context),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.chat_bubble_outline,
                    label: 'Comment',
                    onTap: () => _handleComment(context),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.share_outlined,
                    label: 'Share',
                    onTap: () => _handleShare(context),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    IconData? activeIcon,
    required String label,
    bool isActive = false,
    bool isLoading = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    ? const Color(0xFF6366F1) // Indigo color
                    : SkillWaveAppColors.textSecondary,
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive
                    ? const Color(0xFF6366F1) // Indigo color
                    : SkillWaveAppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLike(BuildContext context) {
    context.read<LikePostBloc>().add(LikePost(post.id));
  }

  void _handleComment(BuildContext context) {
    // TODO: Focus on comment input
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
}
