import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final UserEntity user;
  final String title;
  final String content;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String category;
  final List<String> likes;
  final int views;
  final int engagementScore;
  final List<CommentEntity> comments;
  final List<String> recommendationTypes;

  const PostEntity({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.category,
    required this.likes,
    required this.views,
    required this.engagementScore,
    required this.comments,
    required this.recommendationTypes,
  });

  @override
  List<Object?> get props => [
    id,
    user,
    title,
    content,
    images,
    createdAt,
    updatedAt,
    tags,
    category,
    likes,
    views,
    engagementScore,
    comments,
    recommendationTypes,
  ];
}

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String profilePicture;
  final String bio;
  final List<String> searchHistory;
  final List<String> enrolledCourses;
  final List<String> payments;
  final List<String> blogPosts;
  final List<String> quizResults;
  final List<String> reviews;
  final List<String> certificates;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.bio,
    required this.searchHistory,
    required this.enrolledCourses,
    required this.payments,
    required this.blogPosts,
    required this.quizResults,
    required this.reviews,
    required this.certificates,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    profilePicture,
    bio,
    searchHistory,
    enrolledCourses,
    payments,
    blogPosts,
    quizResults,
    reviews,
    certificates,
    createdAt,
  ];
}

class CommentEntity extends Equatable {
  final UserEntity user;
  final String content;
  final DateTime createdAt;
  final String id;
  final List<ReplyEntity> replies;

  const CommentEntity({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.id,
    required this.replies,
  });

  @override
  List<Object?> get props => [user, content, createdAt, id, replies];
}

class ReplyEntity extends Equatable {
  final UserEntity user;
  final String content;
  final DateTime createdAt;
  final String id;

  const ReplyEntity({
    required this.user,
    required this.content,
    required this.createdAt,
    required this.id,
  });

  @override
  List<Object?> get props => [user, content, createdAt, id];
}

class PostsResponseEntity extends Equatable {
  final List<PostEntity> posts;
  final int totalPosts;
  final int currentPage;
  final int totalPages;
  final Map<String, int> recommendations;
  final List<String> userTags;

  const PostsResponseEntity({
    required this.posts,
    required this.totalPosts,
    required this.currentPage,
    required this.totalPages,
    required this.recommendations,
    required this.userTags,
  });

  @override
  List<Object?> get props => [
    posts,
    totalPosts,
    currentPage,
    totalPages,
    recommendations,
    userTags,
  ];
}
