import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/dashboardScreen/data/models/post_model.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

@LazySingleton()
class DashboardLocalDatasource {
  static const String _postsBoxName = 'dashboard_posts_box';
  static const String _postsKey = 'cached_posts';
  static const String _lastUpdatedKey = 'last_updated';
  static const int _maxCacheSize = 3; // LRU cache size limit

  Box? _postsBox;
  bool _isInitializing = false;

  Future<void> init() async {
    if (_isInitializing || isInitialized) return;

    _isInitializing = true;
    try {
      _postsBox = await Hive.openBox(_postsBoxName);
    } finally {
      _isInitializing = false;
    }
  }

  bool get isInitialized => _postsBox != null;

  /// Save posts to local cache with LRU implementation
  Future<void> cachePosts(List<PostEntity> posts) async {
    if (!isInitialized) {
      throw CacheFailure(message: 'Local datasource not initialized');
    }

    try {
      // Convert posts to JSON for storage
      final postsJson = posts.map((post) => _postEntityToJson(post)).toList();

      // Get current cached posts and convert to JSON format
      final currentCached = _getCachedPosts();
      final currentCachedJson = currentCached
          .map((post) => _postEntityToJson(post))
          .toList();

      // Create new list with new posts at the beginning (most recent)
      final updatedCache = [...postsJson, ...currentCachedJson];

      // Remove duplicates based on post ID (keep most recent)
      final uniqueCache = <Map<String, dynamic>>[];
      final seenIds = <String>{};

      for (final post in updatedCache) {
        final postId = post['id'] as String;
        if (!seenIds.contains(postId)) {
          seenIds.add(postId);
          uniqueCache.add(post);
        }
      }

      // Limit to max cache size (LRU - keep most recent)
      final limitedCache = uniqueCache.take(_maxCacheSize).toList();

      // Save to Hive
      await _postsBox!.put(_postsKey, limitedCache);
      await _postsBox!.put(
        _lastUpdatedKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache posts: ${e.toString()}');
    }
  }

  /// Get cached posts from local storage
  List<PostEntity> getCachedPosts() {
    if (!isInitialized) {
      return [];
    }

    try {
      final cachedData = _postsBox!.get(_postsKey);
      if (cachedData == null) return [];

      final List<dynamic> postsJson = cachedData as List<dynamic>;
      return postsJson
          .map((json) => _jsonToPostEntity(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CacheFailure(
        message: 'Failed to retrieve cached posts: ${e.toString()}',
      );
    }
  }

  /// Get the last updated timestamp
  DateTime? getLastUpdated() {
    if (!isInitialized) {
      return null;
    }

    try {
      final timestamp = _postsBox!.get(_lastUpdatedKey);
      if (timestamp == null) return null;
      return DateTime.fromMillisecondsSinceEpoch(timestamp as int);
    } catch (e) {
      return null;
    }
  }

  /// Check if cache is valid (not older than 1 hour)
  bool isCacheValid() {
    final lastUpdated = getLastUpdated();
    if (lastUpdated == null) return false;

    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inHours < 1; // Cache valid for 1 hour
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    if (!isInitialized) {
      return;
    }

    try {
      await _postsBox!.clear();
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: ${e.toString()}');
    }
  }

  /// Get cached posts with validation
  List<PostEntity> getValidCachedPosts() {
    if (!isCacheValid()) {
      clearCache();
      return [];
    }
    return getCachedPosts();
  }

  /// Check if cache has data
  bool hasCachedData() {
    if (!isInitialized) {
      return false;
    }
    return _postsBox!.get(_postsKey) != null && isCacheValid();
  }

  // Helper methods for JSON conversion
  Map<String, dynamic> _postEntityToJson(PostEntity post) {
    return {
      'id': post.id,
      'user': {
        'id': post.user.id,
        'name': post.user.name,
        'email': post.user.email,
        'role': post.user.role,
        'profilePicture': post.user.profilePicture,
        'bio': post.user.bio,
        'searchHistory': post.user.searchHistory,
        'enrolledCourses': post.user.enrolledCourses,
        'payments': post.user.payments,
        'blogPosts': post.user.blogPosts,
        'quizResults': post.user.quizResults,
        'reviews': post.user.reviews,
        'certificates': post.user.certificates,
        'createdAt': post.user.createdAt.millisecondsSinceEpoch,
      },
      'title': post.title,
      'content': post.content,
      'images': post.images,
      'createdAt': post.createdAt.millisecondsSinceEpoch,
      'updatedAt': post.updatedAt.millisecondsSinceEpoch,
      'tags': post.tags,
      'category': post.category,
      'likes': post.likes,
      'views': post.views,
      'engagementScore': post.engagementScore,
      'comments': post.comments
          .map(
            (comment) => {
              'user': {
                'id': comment.user.id,
                'name': comment.user.name,
                'email': comment.user.email,
                'role': comment.user.role,
                'profilePicture': comment.user.profilePicture,
                'bio': comment.user.bio,
                'searchHistory': comment.user.searchHistory,
                'enrolledCourses': comment.user.enrolledCourses,
                'payments': comment.user.payments,
                'blogPosts': comment.user.blogPosts,
                'quizResults': comment.user.quizResults,
                'reviews': comment.user.reviews,
                'certificates': comment.user.certificates,
                'createdAt': comment.user.createdAt.millisecondsSinceEpoch,
              },
              'content': comment.content,
              'createdAt': comment.createdAt.millisecondsSinceEpoch,
              'id': comment.id,
              'replies': comment.replies
                  .map(
                    (reply) => {
                      'user': {
                        'id': reply.user.id,
                        'name': reply.user.name,
                        'email': reply.user.email,
                        'role': reply.user.role,
                        'profilePicture': reply.user.profilePicture,
                        'bio': reply.user.bio,
                        'searchHistory': reply.user.searchHistory,
                        'enrolledCourses': reply.user.enrolledCourses,
                        'payments': reply.user.payments,
                        'blogPosts': reply.user.blogPosts,
                        'quizResults': reply.user.quizResults,
                        'reviews': reply.user.reviews,
                        'certificates': reply.user.certificates,
                        'createdAt':
                            reply.user.createdAt.millisecondsSinceEpoch,
                      },
                      'content': reply.content,
                      'createdAt': reply.createdAt.millisecondsSinceEpoch,
                      'id': reply.id,
                    },
                  )
                  .toList(),
            },
          )
          .toList(),
      'recommendationTypes': post.recommendationTypes,
    };
  }

  PostEntity _jsonToPostEntity(Map<String, dynamic> json) {
    return PostEntity(
      id: json['id'] as String,
      user: UserEntity(
        id: json['user']['id'] as String,
        name: json['user']['name'] as String,
        email: json['user']['email'] as String,
        role: json['user']['role'] as String,
        profilePicture: json['user']['profilePicture'] as String,
        bio: json['user']['bio'] as String,
        searchHistory: List<String>.from(json['user']['searchHistory']),
        enrolledCourses: List<String>.from(json['user']['enrolledCourses']),
        payments: List<String>.from(json['user']['payments']),
        blogPosts: List<String>.from(json['user']['blogPosts']),
        quizResults: List<String>.from(json['user']['quizResults']),
        reviews: List<String>.from(json['user']['reviews']),
        certificates: List<String>.from(json['user']['certificates']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['user']['createdAt'] as int,
        ),
      ),
      title: json['title'] as String,
      content: json['content'] as String,
      images: List<String>.from(json['images']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      tags: List<String>.from(json['tags']),
      category: json['category'] as String,
      likes: List<String>.from(json['likes']),
      views: json['views'] as int,
      engagementScore: json['engagementScore'] as int,
      comments: (json['comments'] as List<dynamic>).map((commentJson) {
        final comment = commentJson as Map<String, dynamic>;
        return CommentEntity(
          user: UserEntity(
            id: comment['user']['id'] as String,
            name: comment['user']['name'] as String,
            email: comment['user']['email'] as String,
            role: comment['user']['role'] as String,
            profilePicture: comment['user']['profilePicture'] as String,
            bio: comment['user']['bio'] as String,
            searchHistory: List<String>.from(comment['user']['searchHistory']),
            enrolledCourses: List<String>.from(
              comment['user']['enrolledCourses'],
            ),
            payments: List<String>.from(comment['user']['payments']),
            blogPosts: List<String>.from(comment['user']['blogPosts']),
            quizResults: List<String>.from(comment['user']['quizResults']),
            reviews: List<String>.from(comment['user']['reviews']),
            certificates: List<String>.from(comment['user']['certificates']),
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              comment['user']['createdAt'] as int,
            ),
          ),
          content: comment['content'] as String,
          createdAt: DateTime.fromMillisecondsSinceEpoch(
            comment['createdAt'] as int,
          ),
          id: comment['id'] as String,
          replies: (comment['replies'] as List<dynamic>).map((replyJson) {
            final reply = replyJson as Map<String, dynamic>;
            return ReplyEntity(
              user: UserEntity(
                id: reply['user']['id'] as String,
                name: reply['user']['name'] as String,
                email: reply['user']['email'] as String,
                role: reply['user']['role'] as String,
                profilePicture: reply['user']['profilePicture'] as String,
                bio: reply['user']['bio'] as String,
                searchHistory: List<String>.from(
                  reply['user']['searchHistory'],
                ),
                enrolledCourses: List<String>.from(
                  reply['user']['enrolledCourses'],
                ),
                payments: List<String>.from(reply['user']['payments']),
                blogPosts: List<String>.from(reply['user']['blogPosts']),
                quizResults: List<String>.from(reply['user']['quizResults']),
                reviews: List<String>.from(reply['user']['reviews']),
                certificates: List<String>.from(reply['user']['certificates']),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                  reply['user']['createdAt'] as int,
                ),
              ),
              content: reply['content'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                reply['createdAt'] as int,
              ),
              id: reply['id'] as String,
            );
          }).toList(),
        );
      }).toList(),
      recommendationTypes: List<String>.from(json['recommendationTypes']),
    );
  }

  // Private method to get cached posts without validation
  List<PostEntity> _getCachedPosts() {
    if (!isInitialized) {
      return [];
    }

    try {
      final cachedData = _postsBox!.get(_postsKey);
      if (cachedData == null) return [];

      final List<dynamic> postsJson = cachedData as List<dynamic>;
      return postsJson
          .map((json) => _jsonToPostEntity(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
