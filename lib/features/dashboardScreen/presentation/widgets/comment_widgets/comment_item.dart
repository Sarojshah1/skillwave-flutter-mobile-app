import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/constants/api_endpoints.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_dto.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_reply_bloc/create_reply_state.dart';
import 'package:skillwave/features/profileScreen/presentation/bloc/profile_bloc.dart';

class CommentItem extends StatefulWidget {
  final CommentEntity comment;
  final bool isReply;
  final String postId;

  const CommentItem({
    super.key,
    required this.comment,
    this.isReply = false,
    required this.postId,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _isLiked = false;
  int _likesCount = 0;
  bool _isReplying = false;
  bool _showAllReplies = false;
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadUserProfile());
    _likesCount = widget.comment.replies.length;
  }

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
          setState(() => _isReplying = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reply added successfully!'),
              backgroundColor: SkillWaveAppColors.success,
            ),
          );
        } else if (state is CreateReplyError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: SkillWaveAppColors.error,
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: widget.isReply ? 32 : 0,
          top: widget.isReply ? 8 : 0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar
            CircleAvatar(
              radius: 16,
              backgroundColor: SkillWaveAppColors.primary,
              backgroundImage: widget.comment.user.profilePicture.isNotEmpty
                  ? CachedNetworkImageProvider(
                      "${ApiEndpoints.baseUrlForImage}/profile/${widget.comment.user.profilePicture}",
                    )
                  : null,
              child: widget.comment.user.profilePicture.isEmpty
                  ? Text(
                      widget.comment.user.name.substring(0, 1).toUpperCase(),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: SkillWaveAppColors.textInverse,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),

            // Comment content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment bubble
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: SkillWaveAppColors.lightGreyBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.comment.user.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: SkillWaveAppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.comment.content,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: SkillWaveAppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        _buildActionButton(
                          'Like',
                          isActive: _isLiked,
                          onTap: _handleLike,
                        ),
                        const SizedBox(width: 12),
                        _buildActionButton(
                          'Reply',
                          onTap: () =>
                              setState(() => _isReplying = !_isReplying),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatDate(widget.comment.createdAt),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: SkillWaveAppColors.textSecondary,
                          ),
                        ),
                        if (_likesCount > 0) ...[
                          const SizedBox(width: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: _isLiked
                                    ? SkillWaveAppColors.primary
                                    : SkillWaveAppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$_likesCount',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: SkillWaveAppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Reply form
                  if (_isReplying) ...[
                    const SizedBox(height: 8),
                    _buildReplyForm(),
                  ],

                  // Replies
                  if (widget.comment.replies.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildRepliesList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
          color: isActive
              ? SkillWaveAppColors.primary
              : SkillWaveAppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildReplyForm() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            return CircleAvatar(
              radius: 20,
              backgroundColor: SkillWaveAppColors.primary,
              backgroundImage:
                  profileState is ProfileLoaded &&
                      profileState.user.profilePicture.isNotEmpty
                  ? CachedNetworkImageProvider(
                      "http://10.0.2.2:3000/profile/${profileState.user.profilePicture}",
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
            );
          },
        ),
        const SizedBox(width: 8),

        // Reply input
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: SkillWaveAppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              controller: _replyController,
              maxLines: null,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Reply to ${widget.comment.user.name}...',
                hintStyle: AppTextStyles.labelMedium.copyWith(
                  color: SkillWaveAppColors.textDisabled,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        BlocBuilder<CreateReplyBloc, CreateReplyState>(
          builder: (context, state) {
            final isLoading = state is CreateReplyLoading;
            final hasText = _replyController.text.trim().isNotEmpty;

            return ElevatedButton(
              onPressed: _submitReply,
              style: ElevatedButton.styleFrom(
                backgroundColor: SkillWaveAppColors.primary,
                foregroundColor: SkillWaveAppColors.textInverse,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          SkillWaveAppColors.textInverse,
                        ),
                      ),
                    )
                  : Text(
                      'Reply',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: SkillWaveAppColors.textInverse,
                      ),
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRepliesList() {
    // Sort replies by creation date (newest first)
    final sortedReplies = List<ReplyEntity>.from(widget.comment.replies)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final visibleReplies = _showAllReplies
        ? sortedReplies
        : sortedReplies.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_showAllReplies && widget.comment.replies.length > 2)
          TextButton(
            onPressed: () => setState(() => _showAllReplies = true),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: Text(
              'View ${widget.comment.replies.length} replies',
              style: AppTextStyles.labelMedium.copyWith(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),

        ...visibleReplies.map((reply) => _buildReplyItem(reply)),

        if (_showAllReplies && widget.comment.replies.length > 2)
          TextButton(
            onPressed: () => setState(() => _showAllReplies = false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: Text(
              'Hide replies',
              style: AppTextStyles.labelMedium.copyWith(
                color: SkillWaveAppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
      ],
    );
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likesCount += _isLiked ? 1 : -1;
    });
    // TODO: Call like API
  }

  Widget _buildReplyItem(ReplyEntity reply) {
    return Container(
      margin: const EdgeInsets.only(left: 32, top: 8, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: SkillWaveAppColors.primary,
            backgroundImage: reply.user.profilePicture.isNotEmpty
                ? CachedNetworkImageProvider(
                    "http://10.0.2.2:3000/profile/${reply.user.profilePicture}",
                  )
                : null,
            child: reply.user.profilePicture.isEmpty
                ? Text(
                    reply.user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: SkillWaveAppColors.textInverse,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: SkillWaveAppColors.lightGreyBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reply.user.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: SkillWaveAppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reply.content,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: SkillWaveAppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReply() {
    if (_replyController.text.trim().isNotEmpty) {
      final dto = CreateReplyDto(content: _replyController.text.trim());

      context.read<CreateReplyBloc>().add(
        CreateReply(widget.postId, widget.comment.id, dto),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
