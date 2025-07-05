import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_state.dart';

class CommentInput extends StatefulWidget {
  final String postId;

  const CommentInput({super.key, required this.postId});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _commentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCommentBloc, CreateCommentState>(
      listener: (context, state) {
        if (state is CreateCommentLoaded) {
          _commentController.clear();
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Comment added successfully!'),
              backgroundColor: SkillWaveAppColors.success,
            ),
          );
        } else if (state is CreateCommentError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: SkillWaveAppColors.error,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Write a comment...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: SkillWaveAppColors.textDisabled,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: SkillWaveAppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: SkillWaveAppColors.border,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: SkillWaveAppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a comment';
                  }
                  if (value.trim().length < 3) {
                    return 'Comment must be at least 3 characters';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<CreateCommentBloc, CreateCommentState>(
              builder: (context, state) {
                final isLoading =
                    state is CreateCommentLoading || _isSubmitting;

                return IconButton(
                  onPressed: isLoading ? null : _submitComment,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              SkillWaveAppColors.primary,
                            ),
                          ),
                        )
                      : const Icon(Icons.send),
                  color: SkillWaveAppColors.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final dto = CreateCommentDto(content: _commentController.text.trim());

      context.read<CreateCommentBloc>().add(CreateComment(widget.postId, dto));
    }
  }
}
