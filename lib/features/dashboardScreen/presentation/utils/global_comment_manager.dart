import 'package:flutter/foundation.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

class GlobalCommentManager extends ChangeNotifier {
  static final GlobalCommentManager _instance =
      GlobalCommentManager._internal();
  factory GlobalCommentManager() => _instance;
  GlobalCommentManager._internal();

  // Store comments by post ID
  final Map<String, List<CommentEntity>> _commentsByPost = {};

  // Store listeners by post ID
  final Map<String, List<Function(List<CommentEntity>)>> _listeners = {};
  void addComment(String postId, CommentEntity comment) {
    if (!_commentsByPost.containsKey(postId)) {
      _commentsByPost[postId] = [];
    }

    _commentsByPost[postId]!.add(comment);
    _commentsByPost[postId]!.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Notify all listeners for this post
    _notifyListeners(postId);

    debugPrint(
      '✅ Added comment to post $postId. Total comments: ${_commentsByPost[postId]!.length}',
    );
  }

  // Add a reply to a specific comment
  void addReply(String postId, String commentId, ReplyEntity reply) {
    if (_commentsByPost.containsKey(postId)) {
      final commentIndex = _commentsByPost[postId]!.indexWhere(
        (c) => c.id == commentId,
      );
      if (commentIndex != -1) {
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
        _notifyListeners(postId);

        debugPrint('✅ Added reply to comment $commentId in post $postId');
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

  // Add a listener for a specific post
  void addCommentListener(String postId, Function(List<CommentEntity>) listener) {
    if (!_listeners.containsKey(postId)) {
      _listeners[postId] = [];
    }
    _listeners[postId]!.add(listener);
    debugPrint('✅ Added comment listener for post $postId');
  }

  // Remove a listener for a specific post
  void removeCommentListener(String postId, Function(List<CommentEntity>) listener) {
    _listeners[postId]?.remove(listener);
    debugPrint('✅ Removed comment listener for post $postId');
  }

  // Notify all listeners for a specific post
  void _notifyListeners(String postId) {
    final comments = getComments(postId);
    _listeners[postId]?.forEach((listener) {
      try {
        listener(comments);
      } catch (e) {
        debugPrint('❌ Error notifying listener: $e');
      }
    });
  }

  // Get all active post IDs
  Set<String> get activePostIds => _commentsByPost.keys.toSet();

  // Clear all data (for testing or reset)
  void clear() {
    _commentsByPost.clear();
    _listeners.clear();
    debugPrint('✅ Cleared all comment data');
  }
}
