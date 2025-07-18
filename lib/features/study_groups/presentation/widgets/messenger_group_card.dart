import 'package:flutter/material.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class MessengerGroupCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onTap;

  const MessengerGroupCard({Key? key, required this.group, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${ApiEndpoints.baseUrlForImage}${group.groupImage}",
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.grey[200],
                  child: const Icon(Icons.group, size: 28, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.groupName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SkillWaveAppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last message preview...', // Placeholder for last message
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SkillWaveAppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: SkillWaveAppColors.primary.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
