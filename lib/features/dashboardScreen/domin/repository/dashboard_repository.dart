import '../../data/models/post_dto.dart';
import '../entity/post_entity.dart';

abstract class DashboardRepository {
  Future<PostsResponseEntity> getPosts(GetPostsDto dto);
  Future<PostEntity> getPostById(String id);
  Future<PostEntity> createPost(CreatePostDto dto);
  Future<PostEntity> updatePost(String id, UpdatePostDto dto);
  Future<void> deletePost(String id);
  Future<void> likePost(String postId);
  Future<void> createComment(String postId, CreateCommentDto dto);
  Future<void> createReply(String postId, String commentId, CreateReplyDto dto);
}
