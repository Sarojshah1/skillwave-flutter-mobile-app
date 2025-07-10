import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_state.dart';
import 'reply_input.dart';

class ReplySection extends StatelessWidget {
  final String postId;

  const ReplySection({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReplyBloc, CreateReplyState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is CreateReplyLoading)
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
            ReplyInput(postId: postId),
            const SizedBox(height: 12),
            // TODO: Add reply list when get replies BLoC is implemented
            const Text(
              'Replies will be loaded here',
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
