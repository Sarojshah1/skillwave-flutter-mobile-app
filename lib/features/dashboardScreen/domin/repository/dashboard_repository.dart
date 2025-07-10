import '../../data/models/post_dto.dart';
import '../entity/post_entity.dart';

import 'dart:io';

abstract class DashboardRepository {
  Future<PostsResponseEntity> getPosts(GetPostsDto dto);
  Future<PostEntity> getPostById(String id);
  Future<void> createPost(CreatePostDto dto, {List<File>? images});
  Future<PostEntity> updatePost(String id, UpdatePostDto dto);
  Future<void> deletePost(String id);
  Future<void> likePost(String postId);
  Future<void> createComment(String postId, CreateCommentDto dto);
  Future<void> createReply(String postId, String commentId, CreateReplyDto dto);

  /// Get cached posts for offline display
  List<PostEntity> getCachedPosts();

  /// Check if there's cached data available
  bool hasCachedData();

  /// Clear all cached data
  Future<void> clearCache();
}
