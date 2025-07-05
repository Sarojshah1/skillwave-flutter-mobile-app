import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_state.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class CommentSection extends StatelessWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCommentBloc, CreateCommentState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is CreateCommentLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      SkillWaveAppColors.primary,
                    ),
                  ),
                ),
              ),
            CommentInput(postId: postId),
            const SizedBox(height: 12),
            // TODO: Add comment list when get comments BLoC is implemented
            const Text(
              'Comments will be loaded here',
              style: TextStyle(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
