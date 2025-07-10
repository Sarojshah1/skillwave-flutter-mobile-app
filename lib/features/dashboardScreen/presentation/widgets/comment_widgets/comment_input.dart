import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_state.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

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
  void initState() {
    super.initState();
    // Load user profile when widget initializes
    context.read<ProfileBloc>().add(LoadUserProfile());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateCommentBloc, CreateCommentState>(
      listener: (context, state) {
        // Only update state if widget is still mounted
        if (!mounted) return;

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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return Form(
            key: _formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: SkillWaveAppColors.primary,
                  backgroundImage:
                      profileState is ProfileLoaded &&
                          profileState.user.profilePicture.isNotEmpty
                      ? CachedNetworkImageProvider(
                          "${ApiEndpoints.baseUrlForImage}/profile/${profileState.user.profilePicture}",
                        )
                      : null,
                  child: profileState is ProfileLoaded
                      ? (profileState.user.profilePicture.isEmpty
                            ? Text(
                                profileState.user.name
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: SkillWaveAppColors.textInverse,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null)
                      : const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            SkillWaveAppColors.primary,
                          ),
                        ),
                ),
                const SizedBox(width: 12),

                // Comment input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: SkillWaveAppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _commentController,
                      maxLines: null,
                      minLines: 1,
                      maxLength: 500,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: SkillWaveAppColors.textDisabled,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Add emoji picker
                              },
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                                size: 20,
                                color: SkillWaveAppColors.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Add image picker
                              },
                              icon: const Icon(
                                Icons.image_outlined,
                                size: 20,
                                color: SkillWaveAppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                ),
                const SizedBox(width: 12),
                BlocBuilder<CreateCommentBloc, CreateCommentState>(
                  builder: (context, state) {
                    final isLoading =
                        state is CreateCommentLoading || _isSubmitting;
                    final hasText = _commentController.text.trim().isNotEmpty;
                    final canSubmit = hasText && profileState is ProfileLoaded;

                    return IconButton(
                      onPressed: _submitComment,
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
                      color: canSubmit
                          ? SkillWaveAppColors.primary
                          : SkillWaveAppColors.textDisabled,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitComment() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final dto = CreateCommentDto(content: _commentController.text.trim());
      print('Submitting comment: ${dto.content}');
    // final mounted = context.mounted;
      if (mounted) {
        try {
          context.read<CreateCommentBloc>().add(
            CreateComment(widget.postId, dto),
          );
        } catch (e) {
          if (mounted) {
            setState(() => _isSubmitting = false);
          }
        }
      } else {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
