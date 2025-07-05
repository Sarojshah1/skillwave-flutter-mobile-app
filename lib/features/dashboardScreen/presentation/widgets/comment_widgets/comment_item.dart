import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  final VoidCallback? onReply;

  const CommentItem({super.key, required this.comment, this.onReply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: SkillWaveAppColors.primary,
            backgroundImage: comment.user.profilePicture.isNotEmpty
                ? NetworkImage(comment.user.profilePicture)
                : null,
            child: comment.user.profilePicture.isEmpty
                ? Text(
                    comment.user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: SkillWaveAppColors.textInverse,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.user.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: SkillWaveAppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(comment.createdAt),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: SkillWaveAppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: SkillWaveAppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: onReply,
                      child: Text(
                        'Reply',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: SkillWaveAppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (comment.replies.isNotEmpty) ...[
                      const SizedBox(width: 16),
                      Text(
                        '${comment.replies.length} replies',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: SkillWaveAppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                if (comment.replies.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildRepliesList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesList() {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SkillWaveAppColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: comment.replies.map((reply) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: SkillWaveAppColors.primary,
                  backgroundImage: reply.user.profilePicture.isNotEmpty
                      ? NetworkImage(reply.user.profilePicture)
                      : null,
                  child: reply.user.profilePicture.isEmpty
                      ? Text(
                          reply.user.name.substring(0, 1).toUpperCase(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: SkillWaveAppColors.textInverse,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            reply.user.name,
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: SkillWaveAppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(reply.createdAt),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: SkillWaveAppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reply.content,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: SkillWaveAppColors.textSecondary,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
