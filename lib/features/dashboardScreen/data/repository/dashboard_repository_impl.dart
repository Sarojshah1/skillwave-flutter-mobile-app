import 'dart:io';
import 'package:injectable/injectable.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../../domin/repository/dashboard_repository.dart';
import '../models/post_dto.dart';
import '../../domin/entity/post_entity.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;
  final DashboardLocalDatasource localDatasource;

  DashboardRepositoryImpl(this.remoteDatasource, this.localDatasource);

  @override
  Future<PostsResponseEntity> getPosts(GetPostsDto dto) async {
    try {
      // Try to get data from remote first
      final remoteData = await remoteDatasource.getPosts(dto);

      // Ensure local datasource is initialized before caching
      await localDatasource.init();

      // Cache the posts locally
      await localDatasource.cachePosts(remoteData.posts);

      return remoteData;
    } catch (e) {
      // If remote fails, try to get from local cache
      // Ensure local datasource is initialized
      await localDatasource.init();

      final cachedPosts = localDatasource.getValidCachedPosts();

      if (cachedPosts.isNotEmpty) {
        // Return cached data with offline indicator
        return PostsResponseEntity(
          posts: cachedPosts,
          totalPosts: cachedPosts.length,
          currentPage: 1,
          totalPages: 1,
          recommendations: {},
          userTags: [],
        );
      }
      rethrow;
    }
  }

  @override
  Future<PostEntity> getPostById(String id) async {
    try {

      final remoteData = await remoteDatasource.getPostById(id);

      // Ensure local datasource is initialized before caching
      await localDatasource.init();

      // Cache the single post locally
      await localDatasource.cachePosts([remoteData]);

      return remoteData;
    } catch (e) {
      // If remote fails, try to get from local cache
      // Ensure local datasource is initialized
      await localDatasource.init();

      final cachedPosts = localDatasource.getValidCachedPosts();
      final cachedPost = cachedPosts.where((post) => post.id == id).firstOrNull;

      if (cachedPost != null) {
        return cachedPost;
      }

      // If no cached data, rethrow the original error
      rethrow;
    }
  }

  @override
  Future<void> createPost(CreatePostDto dto, {List<File>? images}) async {
    return await remoteDatasource.createPost(dto, images: images);
  }

  @override
  Future<PostEntity> updatePost(String id, UpdatePostDto dto) async {
    return await remoteDatasource.updatePost(id, dto);
  }

  @override
  Future<void> deletePost(String id) async {
    return await remoteDatasource.deletePost(id);
  }

  @override
  Future<void> likePost(String postId) async {
    return await remoteDatasource.likePost(postId);
  }

  @override
  Future<void> createComment(String postId, CreateCommentDto dto) async {
    return await remoteDatasource.createComment(postId, dto);
  }

  @override
  Future<void> createReply(
    String postId,
    String commentId,
    CreateReplyDto dto,
  ) async {
    return await remoteDatasource.createReply(postId, commentId, dto);
  }

  /// Get cached posts for offline display
  @override
  List<PostEntity> getCachedPosts() {
    // Initialize if needed (synchronous fallback)
    if (!localDatasource.isInitialized) {
      return [];
    }
    return localDatasource.getValidCachedPosts();
  }

  /// Check if there's cached data available
  @override
  bool hasCachedData() {
    // Initialize if needed (synchronous fallback)
    if (!localDatasource.isInitialized) {
      return false;
    }
    return localDatasource.hasCachedData();
  }

  /// Clear all cached data
  @override
  Future<void> clearCache() async {
    await localDatasource.init();
    await localDatasource.clearCache();
  }
}
