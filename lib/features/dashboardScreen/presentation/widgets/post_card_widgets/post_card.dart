import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/like_post_bloc/like_post_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/comment_widgets/comment_section.dart';
import 'package:skillwave/features/dashboardScreen/presentation/widgets/reply_widgets/reply_section.dart';
import 'post_card_header.dart';
import 'post_card_content.dart';
import 'post_card_actions.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

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
      ],
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCardHeader(user: post.user),
                const SizedBox(height: 12),
                PostCardContent(post: post),
                const SizedBox(height: 16),
                PostCardActions(post: post),
                const SizedBox(height: 12),
                CommentSection(postId: post.id),
                const SizedBox(height: 8),
                ReplySection(postId: post.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
