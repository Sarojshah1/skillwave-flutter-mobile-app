import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class PostCardContent extends StatelessWidget {
  final PostEntity post;

  const PostCardContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              post.title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: SkillWaveAppColors.textPrimary,
              ),
            ),
          ),
        if (post.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              post.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: SkillWaveAppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        if (post.images.isNotEmpty) _buildImageGrid(),
        if (post.tags.isNotEmpty) _buildTags(),
      ],
    );
  }

  Widget _buildImageGrid() {
    if (post.images.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: "http://10.0.2.2:3000/${post.images.first}",
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: SkillWaveAppColors.lightGreyBackground,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: SkillWaveAppColors.lightGreyBackground,
              child: const Icon(
                Icons.image_not_supported,
                color: SkillWaveAppColors.textDisabled,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: post.images.length == 2 ? 2 : 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1,
        ),
        itemCount: post.images.length > 6 ? 6 : post.images.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: "http://10.0.2.2:3000/${post.images[index]}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: SkillWaveAppColors.lightGreyBackground,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: SkillWaveAppColors.lightGreyBackground,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: SkillWaveAppColors.textDisabled,
                    ),
                  ),
                ),
                if (index == 5 && post.images.length > 6)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '+${post.images.length - 6}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: SkillWaveAppColors.textInverse,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: post.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: SkillWaveAppColors.lightBlueBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SkillWaveAppColors.border, width: 1),
          ),
          child: Text(
            '#$tag',
            style: AppTextStyles.labelMedium.copyWith(
              color: SkillWaveAppColors.primary,
            ),
          ),
        );
      }).toList(),
    );
  }
}
