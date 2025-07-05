import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class PostCardHeader extends StatelessWidget {
  final UserEntity user;

  const PostCardHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: SkillWaveAppColors.primary,
          backgroundImage: user.profilePicture.isNotEmpty
              ? NetworkImage(user.profilePicture)
              : null,
          child: user.profilePicture.isEmpty
              ? Text(
                  user.name.substring(0, 1).toUpperCase(),
                  style: AppTextStyles.bodyMedium.copyWith(
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
              Text(
                user.name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SkillWaveAppColors.textPrimary,
                ),
              ),
              Text(
                user.email,
                style: AppTextStyles.labelMedium.copyWith(
                  color: SkillWaveAppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement more options
          },
          icon: const Icon(Icons.more_vert),
          color: SkillWaveAppColors.textSecondary,
        ),
      ],
    );
  }
}
