import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/dashboardScreen/domin/entity/post_entity.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required UserModel user,
    required String title,
    required String content,
    required List<String> images,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    required List<String> tags,
    required String category,
    required List<String> likes,
    required int views,
    @JsonKey(name: 'engagement_score') required int engagementScore,
    required List<CommentModel> comments,
    required List<String> recommendationTypes,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'profile_picture') required String profilePicture,
    required String bio,
    @JsonKey(name: 'search_history') required List<String> searchHistory,
    @JsonKey(name: 'enrolled_courses') required List<String> enrolledCourses,
    required List<String> payments,
    @JsonKey(name: 'blog_posts') required List<String> blogPosts,
    @JsonKey(name: 'quiz_results') required List<String> quizResults,
    required List<String> reviews,
    required List<String> certificates,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    @JsonKey(name: 'user_id') required UserModel user,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: '_id') required String id,
    required List<ReplyModel> replies,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);
}

@freezed
class ReplyModel with _$ReplyModel {
  const factory ReplyModel({
    @JsonKey(name: 'user_id') required UserModel user,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: '_id') required String id,
  }) = _ReplyModel;

  factory ReplyModel.fromJson(Map<String, dynamic> json) =>
      _$ReplyModelFromJson(json);
}

@freezed
class PostsResponseModel with _$PostsResponseModel {
  const factory PostsResponseModel({
    required List<PostModel> posts,
    required int totalPosts,
    required int currentPage,
    required int totalPages,
    required Map<String, int> recommendations,
    required List<String> userTags,
  }) = _PostsResponseModel;

  factory PostsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostsResponseModelFromJson(json);
}

// Extension methods to convert to entities
extension PostModelExtension on PostModel {
  PostEntity toEntity() {
    return PostEntity(
      id: id,
      user: user.toEntity(),
      title: title,
      content: content,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
      tags: tags,
      category: category,
      likes: likes,
      views: views,
      engagementScore: engagementScore,
      comments: comments.map((comment) => comment.toEntity()).toList(),
      recommendationTypes: recommendationTypes,
    );
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: role,
      profilePicture: profilePicture,
      bio: bio,
      searchHistory: searchHistory,
      enrolledCourses: enrolledCourses,
      payments: payments,
      blogPosts: blogPosts,
      quizResults: quizResults,
      reviews: reviews,
      certificates: certificates,
      createdAt: createdAt,
    );
  }
}

extension CommentModelExtension on CommentModel {
  CommentEntity toEntity() {
    return CommentEntity(
      user: user.toEntity(),
      content: content,
      createdAt: createdAt,
      id: id,
      replies: replies.map((reply) => reply.toEntity()).toList(),
    );
  }
}

extension ReplyModelExtension on ReplyModel {
  ReplyEntity toEntity() {
    return ReplyEntity(
      user: user.toEntity(),
      content: content,
      createdAt: createdAt,
      id: id,
    );
  }
}

extension PostsResponseModelExtension on PostsResponseModel {
  PostsResponseEntity toEntity() {
    return PostsResponseEntity(
      posts: posts.map((post) => post.toEntity()).toList(),
      totalPosts: totalPosts,
      currentPage: currentPage,
      totalPages: totalPages,
      recommendations: recommendations,
      userTags: userTags,
    );
  }
}
