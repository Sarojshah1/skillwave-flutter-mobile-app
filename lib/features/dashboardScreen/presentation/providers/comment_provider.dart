import 'package:flutter/foundation.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class CommentProvider extends ChangeNotifier {
  static final CommentProvider _instance = CommentProvider._internal();
  factory CommentProvider() => _instance;
  CommentProvider._internal();

  // Store comments by post ID
  final Map<String, List<CommentEntity>> _commentsByPost = {};

  // Add a comment to a specific post
  void addComment(String postId, CommentEntity comment) {
    if (!_commentsByPost.containsKey(postId)) {
      _commentsByPost[postId] = [];
    }

    // Check if comment already exists
    final exists = _commentsByPost[postId]!.any((c) => c.id == comment.id);
    if (!exists) {
      _commentsByPost[postId]!.add(comment);
      _commentsByPost[postId]!.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      debugPrint(
        '✅ Added comment to post $postId. Total comments: ${_commentsByPost[postId]!.length}',
      );
      notifyListeners();
    }
  }

  // Add a reply to a specific comment
  void addReply(String postId, String commentId, ReplyEntity reply) {
    if (_commentsByPost.containsKey(postId)) {
      final commentIndex = _commentsByPost[postId]!.indexWhere(
        (c) => c.id == commentId,
      );
      if (commentIndex != -1) {
        // Check if reply already exists
        final exists = _commentsByPost[postId]![commentIndex].replies.any(
          (r) => r.id == reply.id,
        );
        if (!exists) {
          final updatedReplies = [
            ..._commentsByPost[postId]![commentIndex].replies,
            reply,
          ];
          updatedReplies.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          final updatedComment = CommentEntity(
            id: _commentsByPost[postId]![commentIndex].id,
            user: _commentsByPost[postId]![commentIndex].user,
            content: _commentsByPost[postId]![commentIndex].content,
            createdAt: _commentsByPost[postId]![commentIndex].createdAt,
            replies: updatedReplies,
          );

          _commentsByPost[postId]![commentIndex] = updatedComment;
          debugPrint('✅ Added reply to comment $commentId in post $postId');
          notifyListeners();
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
      notifyListeners();
    }
  }

  // Get all active post IDs
  Set<String> get activePostIds => _commentsByPost.keys.toSet();

  // Clear all data (for testing or reset)
  void clear() {
    _commentsByPost.clear();
    debugPrint('✅ Cleared all comment data');
    notifyListeners();
  }
}
