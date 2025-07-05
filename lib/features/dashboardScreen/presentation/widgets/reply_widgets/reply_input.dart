import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_state.dart';

class ReplyInput extends StatefulWidget {
  final String postId;

  const ReplyInput({super.key, required this.postId});

  @override
  State<ReplyInput> createState() => _ReplyInputState();
}

class _ReplyInputState extends State<ReplyInput> {
  final TextEditingController _replyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateReplyBloc, CreateReplyState>(
      listener: (context, state) {
        if (state is CreateReplyLoaded) {
          _replyController.clear();
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reply added successfully!'),
              backgroundColor: SkillWaveAppColors.success,
            ),
          );
        } else if (state is CreateReplyError) {
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
                controller: _replyController,
                decoration: InputDecoration(
                  hintText: 'Write a reply...',
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
                    return 'Please enter a reply';
                  }
                  if (value.trim().length < 3) {
                    return 'Reply must be at least 3 characters';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            BlocBuilder<CreateReplyBloc, CreateReplyState>(
              builder: (context, state) {
                final isLoading = state is CreateReplyLoading || _isSubmitting;

                return IconButton(
                  onPressed: isLoading ? null : _submitReply,
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
                      : const Icon(Icons.reply),
                  color: SkillWaveAppColors.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submitReply() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final dto = CreateReplyDto(content: _replyController.text.trim());

      context.read<CreateReplyBloc>().add(
        CreateReply(widget.postId, 'comment_id', dto), // TODO: Get comment ID
      );
    }
  }
}
