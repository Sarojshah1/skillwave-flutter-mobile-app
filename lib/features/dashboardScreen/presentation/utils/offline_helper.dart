import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';
import 'package:skillwave/features/dashboardScreen/domin/repository/dashboard_repository.dart';

/// Helper class to manage offline functionality for dashboard
class OfflineHelper {
  final DashboardRepository _repository;

  OfflineHelper(this._repository);

  /// Check if user is offline and has cached data
  bool isOfflineWithData() {
    return _repository.hasCachedData();
  }

  /// Get cached posts for offline display
  List<PostEntity> getOfflinePosts() {
    return _repository.getCachedPosts();
  }

  /// Get offline posts response entity
  PostsResponseEntity getOfflinePostsResponse() {
    final cachedPosts = _repository.getCachedPosts();

    return PostsResponseEntity(
      posts: cachedPosts,
      totalPosts: cachedPosts.length,
      currentPage: 1,
      totalPages: 1,
      recommendations: {},
      userTags: [],
    );
  }

  /// Clear all cached data
  Future<void> clearOfflineData() async {
    await _repository.clearCache();
  }

  /// Get offline status message
  String getOfflineMessage() {
    final cachedPosts = _repository.getCachedPosts();
    return 'You are currently offline. Showing ${cachedPosts.length} cached posts.';
  }

  /// Check if there are any cached posts
  bool hasCachedPosts() {
    return _repository.getCachedPosts().isNotEmpty;
  }

  /// Get the number of cached posts
  int getCachedPostsCount() {
    return _repository.getCachedPosts().length;
  }
}
