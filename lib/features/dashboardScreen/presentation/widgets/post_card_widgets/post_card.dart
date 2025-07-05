import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/comment_widgets/comment_section.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/reply_widgets/reply_section.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/realtime_comment_bloc.dart';
import 'package:skillwave/config/di/di.container.dart';
import 'post_card_header.dart';
import 'post_card_content.dart';
import 'post_card_actions.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LikePostBloc>(
          create: (context) => context.read<LikePostBloc>(),
        ),
        BlocProvider<CreateCommentBloc>(
          create: (context) => context.read<CreateCommentBloc>(),
        ),
        // Use the shared RealtimeCommentBloc from the parent
        BlocProvider<RealtimeCommentBloc>.value(
          value: context.read<RealtimeCommentBloc>(),
        ),
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: SkillWaveAppColors.border, width: 1),
        ),
        child: InkWell(
          // onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with colored background
              Container(
                decoration: const BoxDecoration(
                  color: SkillWaveAppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: PostCardHeader(
                  user: post.user,
                  createdAt: post.createdAt,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: PostCardContent(post: post),
              ),
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    if (post.likes.isNotEmpty)
                      Text(
                        '${post.likes.length} likes',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: SkillWaveAppColors.textSecondary,
                        ),
                      ),
                    const Spacer(),
                    if (post.comments.isNotEmpty)
                      Text(
                        '${post.comments.length} comments',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: SkillWaveAppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Divider
              const Divider(color: SkillWaveAppColors.border, height: 1),
              // Actions
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: PostCardActions(post: post),
              ),
              const Divider(color: SkillWaveAppColors.border, height: 1),
              // Comments and Replies
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CommentSection(postId: post.id, comments: post.comments),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
