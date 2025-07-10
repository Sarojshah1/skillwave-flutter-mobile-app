import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class PostCardHeader extends StatelessWidget {
  final UserEntity user;
  final DateTime createdAt;

  const PostCardHeader({
    super.key,
    required this.user,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    print(user.profilePicture);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: SkillWaveAppColors.textInverse,
            backgroundImage: user.profilePicture.isNotEmpty
                ? CachedNetworkImageProvider(
                    "${ApiEndpoints.baseUrlForImage}/profile/${user.profilePicture}",
                  )
                : null,
            child: user.profilePicture.isEmpty
                ? Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: SkillWaveAppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SkillWaveAppColors.textInverse,
                  ),
                ),
                Text(
                  _formatDate(createdAt), // TODO: Use actual post date
                  style: AppTextStyles.labelMedium.copyWith(
                    color: SkillWaveAppColors.textInverse.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: SkillWaveAppColors.textInverse,
            ),
            onSelected: (value) {
              // TODO: Handle menu actions
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'save', child: Text('Save post')),
              const PopupMenuItem(value: 'hide', child: Text('Hide post')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'report',
                child: Text(
                  'Report post',
                  style: TextStyle(color: SkillWaveAppColors.error),
                ),
              ),
            ],
          ),
        ],
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
