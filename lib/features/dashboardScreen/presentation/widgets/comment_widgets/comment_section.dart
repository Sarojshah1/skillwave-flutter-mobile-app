import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillwave/config/themes/app_themes_color.dart';
import 'package:skillwave/config/themes/app_text_styles.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_events.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/create_comment_bloc/create_comment_state.dart';
import 'package:skillwave/features/dashboardScreen/presentation/bloc/realtime_comment_bloc.dart';
import 'package:skillwave/features/dashboardScreen/presentation/utils/global_comment_store.dart';
import 'comment_item.dart';
import 'comment_input.dart';

class CommentSection extends StatefulWidget {
  final String postId;
  final List<CommentEntity> comments;

  const CommentSection({
    super.key,
    required this.postId,
    required this.comments,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  bool _showAllComments = false;
  late RealtimeCommentBloc _realtimeBloc;
  late GlobalCommentStore _commentStore;
  List<CommentEntity> _comments = [];

  @override
  void initState() {
    super.initState();
    _realtimeBloc = context.read<RealtimeCommentBloc>();
    _commentStore = GlobalCommentStore();

    // Initialize comments from global store or widget
    final globalComments = _commentStore.getComments(widget.postId);
    if (globalComments.isNotEmpty) {
      _comments = List.from(globalComments)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      print('✅ Loaded comments from global store: ${_comments.length}');
    } else {
      // Use widget comments if no global comments and initialize global store
      _comments = List.from(widget.comments)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _commentStore.initializeComments(widget.postId, _comments);
      print('✅ Initialized comments from widget: ${_comments.length}');
    }

    // Use a post-frame callback to ensure the widget is properly mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          _realtimeBloc.add(JoinPostRoom(postId: widget.postId));
        } catch (e) {
          // BLoC might be closed, ignore the error
        }
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      try {
        _realtimeBloc.add(LeavePostRoom(postId: widget.postId));
      } catch (e) {
        // BLoC might be closed, ignore the error
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealtimeCommentBloc, RealtimeCommentState>(
      listener: (context, state) {
        if (state is RealtimeCommentNewComment) {
          final commentData = state.data;

          final receivedPostId = commentData['postId'];

          if (receivedPostId == widget.postId) {
            final comment = commentData['comment'] ?? commentData;
            if (comment != null) {
              final newComment = CommentEntity(
                id: comment['_id'] ?? comment['id'] ?? '',
                content: comment['content'] ?? '',
                user: UserEntity(
                  id:
                      comment['user_id']?['_id'] ??
                      comment['user']?['_id'] ??
                      '',
                  name:
                      comment['user_id']?['name'] ??
                      comment['user']?['name'] ??
                      'Unknown User',
                  email:
                      comment['user_id']?['email'] ??
                      comment['user']?['email'] ??
                      '',
                  profilePicture:
                      comment['user_id']?['profile_picture'] ??
                      comment['user']?['profile_picture'] ??
                      '',
                  bio:
                      comment['user_id']?['bio'] ??
                      comment['user']?['bio'] ??
                      '',
                  role:
                      comment['user_id']?['role'] ??
                      comment['user']?['role'] ??
                      'student',
                  searchHistory: [],
                  enrolledCourses: [],
                  payments: [],
                  blogPosts: [],
                  quizResults: [],
                  reviews: [],
                  certificates: [],
                  createdAt:
                      DateTime.tryParse(
                        comment['user_id']?['created_at'] ??
                            comment['user']?['created_at'] ??
                            '',
                      ) ??
                      DateTime.now(),
                ),
                createdAt:
                    DateTime.tryParse(comment['created_at'] ?? '') ??
                    DateTime.now(),
                replies: [], // Initialize with empty replies
              );

              // Add to global store and local state
              _commentStore.addComment(widget.postId, newComment);
              setState(() {
                _comments.add(newComment);
                _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                print(
                  '✅ Comment added to list. Total comments: ${_comments.length}',
                );
              });
            }
          } else {
            print(
              '❌ Post ID mismatch. Expected: ${widget.postId}, Received: $receivedPostId',
            );
          }
        } else if (state is RealtimeCommentNewReply) {
          // Handle new reply received
          final replyData = state.data;
          print('🔍 Received reply data: $replyData');

          final receivedPostId =
              replyData['postId'] ?? replyData['post_id'] ?? replyData['post'];
          if (receivedPostId == widget.postId) {
            print('✅ Post ID matches for reply, adding reply');
            // Add new reply to the appropriate comment
            final reply = replyData['reply'] ?? replyData;
            final commentId = replyData['commentId'] ?? replyData['comment_id'];

            if (reply != null && commentId != null) {
              print('🔍 Reply data: $reply');
              print('🔍 Comment ID: $commentId');
              // Create a new ReplyEntity from the received data
              final newReply = ReplyEntity(
                id: reply['_id'] ?? reply['id'] ?? '',
                content: reply['content'] ?? '',
                user: UserEntity(
                  id: reply['user_id']?['_id'] ?? reply['user']?['_id'] ?? '',
                  name:
                      reply['user_id']?['name'] ??
                      reply['user']?['name'] ??
                      'Unknown User',
                  email:
                      reply['user_id']?['email'] ??
                      reply['user']?['email'] ??
                      '',
                  profilePicture:
                      reply['user_id']?['profile_picture'] ??
                      reply['user']?['profile_picture'] ??
                      '',
                  bio: reply['user_id']?['bio'] ?? reply['user']?['bio'] ?? '',
                  role:
                      reply['user_id']?['role'] ??
                      reply['user']?['role'] ??
                      'student',
                  searchHistory: [],
                  enrolledCourses: [],
                  payments: [],
                  blogPosts: [],
                  quizResults: [],
                  reviews: [],
                  certificates: [],
                  createdAt:
                      DateTime.tryParse(
                        reply['user_id']?['created_at'] ??
                            reply['user']?['created_at'] ??
                            '',
                      ) ??
                      DateTime.now(),
                ),
                createdAt:
                    DateTime.tryParse(reply['created_at'] ?? '') ??
                    DateTime.now(),
              );

              // Find the comment and add the reply
              setState(() {
                final commentIndex = _comments.indexWhere(
                  (c) => c.id == commentId,
                );
                if (commentIndex != -1) {
                  final updatedReplies = [
                    ..._comments[commentIndex].replies,
                    newReply,
                  ];
                  // Sort replies by creation date (newest first)
                  updatedReplies.sort(
                    (a, b) => b.createdAt.compareTo(a.createdAt),
                  );

                  final updatedComment = CommentEntity(
                    id: _comments[commentIndex].id,
                    user: _comments[commentIndex].user,
                    content: _comments[commentIndex].content,
                    createdAt: _comments[commentIndex].createdAt,
                    replies: updatedReplies,
                  );
                  _comments[commentIndex] = updatedComment;
                  // Add reply to global store
                  _commentStore.addReply(widget.postId, commentId, newReply);
                  print(
                    '✅ Reply added to comment. Total replies: ${updatedReplies.length}',
                  );
                } else {
                  print(
                    '❌ Comment not found for reply. Comment ID: $commentId',
                  );
                }
              });
            }
          } else {
            print(
              '❌ Post ID mismatch for reply. Expected: ${widget.postId}, Received: $receivedPostId',
            );
          }
        }
      },
      child: BlocBuilder<CreateCommentBloc, CreateCommentState>(
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

              // Comment input
              CommentInput(postId: widget.postId),

              const SizedBox(height: 16),

              // Comments list
              _buildCommentsList(),

              // Show more/less comments button
              if (_comments.length > 1)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllComments = !_showAllComments;
                    });
                  },
                  child: Text(
                    _showAllComments
                        ? 'Show fewer comments'
                        : 'View all ${_comments.length} comments',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: SkillWaveAppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommentsList() {
    print('🔍 Building comments list. Total comments: ${_comments.length}');
    final visibleComments = _showAllComments
        ? _comments
        : _comments.take(1).toList();

    print('🔍 Visible comments: ${visibleComments.length}');

    if (visibleComments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: visibleComments.map((comment) {
        return CommentItem(comment: comment, postId: widget.postId);
      }).toList(),
    );
  }
}
