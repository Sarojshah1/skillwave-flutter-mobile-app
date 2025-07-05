import 'package:flutter/foundation.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class GlobalCommentStore {
  static final GlobalCommentStore _instance = GlobalCommentStore._internal();
  factory GlobalCommentStore() => _instance;
  GlobalCommentStore._internal();

  // Store comments by post ID
  final Map<String, List<CommentEntity>> _commentsByPost = {};

  // Add a comment to ALL posts
  void addComment(String postId, CommentEntity comment) {
    // Add comment to ALL active posts
    for (String activePostId in _commentsByPost.keys) {
      // Check if comment already exists in this post
      final exists = _commentsByPost[activePostId]!.any(
        (c) => c.id == comment.id,
      );
      if (!exists) {
        _commentsByPost[activePostId]!.add(comment);
        _commentsByPost[activePostId]!.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );
        debugPrint(
          '✅ Added comment to post $activePostId. Total comments: ${_commentsByPost[activePostId]!.length}',
        );
      }
    }

    // Also add to the original post if it's not in the active posts
    if (!_commentsByPost.containsKey(postId)) {
      _commentsByPost[postId] = [];
    }
    final exists = _commentsByPost[postId]!.any((c) => c.id == comment.id);
    if (!exists) {
      _commentsByPost[postId]!.add(comment);
      _commentsByPost[postId]!.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
      debugPrint(
        '✅ Added comment to original post $postId. Total comments: ${_commentsByPost[postId]!.length}',
      );
    }
  }

  // Add a reply to ALL posts
  void addReply(String postId, String commentId, ReplyEntity reply) {
    // Add reply to ALL active posts
    for (String activePostId in _commentsByPost.keys) {
      if (_commentsByPost.containsKey(activePostId)) {
        final commentIndex = _commentsByPost[activePostId]!.indexWhere(
          (c) => c.id == commentId,
        );
        if (commentIndex != -1) {
          // Check if reply already exists
          final exists = _commentsByPost[activePostId]![commentIndex].replies
              .any((r) => r.id == reply.id);
          if (!exists) {
            final updatedReplies = [
              ..._commentsByPost[activePostId]![commentIndex].replies,
              reply,
            ];
            updatedReplies.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            final updatedComment = CommentEntity(
              id: _commentsByPost[activePostId]![commentIndex].id,
              user: _commentsByPost[activePostId]![commentIndex].user,
              content: _commentsByPost[activePostId]![commentIndex].content,
              createdAt: _commentsByPost[activePostId]![commentIndex].createdAt,
              replies: updatedReplies,
            );

            _commentsByPost[activePostId]![commentIndex] = updatedComment;
            debugPrint(
              '✅ Added reply to comment $commentId in post $activePostId',
            );
          }
        }
      }
    }
  }

  // Get comments for a specific post
  List<CommentEntity> getComments(String postId) {
    return _commentsByPost[postId] ?? [];
  }

  // Initialize comments for a post
  void initializeComments(String postId, List<CommentEntity> comments) {
    if (!_commentsByPost.containsKey(postId)) {
      _commentsByPost[postId] = List.from(comments)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      debugPrint(
        '✅ Initialized comments for post $postId. Count: ${comments.length}',
      );
    }
  }

  // Get all active post IDs
  Set<String> get activePostIds => _commentsByPost.keys.toSet();

  // Clear all data (for testing or reset)
  void clear() {
    _commentsByPost.clear();
    debugPrint('✅ Cleared all comment data');
  }
}
