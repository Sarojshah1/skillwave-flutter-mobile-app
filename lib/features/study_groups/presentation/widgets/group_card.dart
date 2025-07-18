import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:skillwave/features/study_groups/domain/entity/group_entity.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';

class GroupCard extends StatelessWidget {
  final GroupEntity group;
  final VoidCallback? onJoin;
  final bool isJoined;

  const GroupCard({
    Key? key,
    required this.group,
    this.onJoin,
    this.isJoined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: SkillWaveAppColors.backgroundGradient_2,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${ApiEndpoints.baseUrlForImage}${group.groupImage}",
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 72,
                          height: 72,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.group,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.groupName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: SkillWaveAppColors.primary,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            group.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: SkillWaveAppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundImage:
                                    group.createdBy.profilePicture.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        group.createdBy.profilePicture
                                                .startsWith('http')
                                            ? group.createdBy.profilePicture
                                            : "${ApiEndpoints.baseUrlForImage}/profile/${group.createdBy.profilePicture}",
                                      )
                                    : null,
                                child: group.createdBy.profilePicture.isEmpty
                                    ? Text(
                                        group.createdBy.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                group.createdBy.name,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: SkillWaveAppColors.textPrimary,
                                    ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.people,
                                size: 18,
                                color: SkillWaveAppColors.primary.withOpacity(
                                  0.7,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${group.members.length} members',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: SkillWaveAppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isJoined
                          ? Container(
                              key: const ValueKey('joined'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: SkillWaveAppColors.success.withOpacity(
                                  0.12,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.check_circle,
                                    color: SkillWaveAppColors.success,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Joined',
                                    style: TextStyle(
                                      color: SkillWaveAppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ElevatedButton.icon(
                              key: const ValueKey('join'),
                              onPressed: onJoin,
                              icon: const Icon(Icons.group_add, size: 20),
                              label: const Text(
                                'Join Group',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SkillWaveAppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                elevation: 2,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
