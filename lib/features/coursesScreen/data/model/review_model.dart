import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    required String role,
    @JsonKey(name: 'profile_picture') required String profilePicture,
    required String bio,
    @JsonKey(name: 'enrolled_courses') required List<String> enrolledCourses,
    required List<String> payments,
    @JsonKey(name: 'blog_posts') required List<String> blogPosts,
    @JsonKey(name: 'quiz_results') required List<String> quizResults,
    required List<String> reviews,
    required List<String> certificates,
    @JsonKey(name: 'search_history') required List<String> searchHistory,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
    id: entity.id,
    name: entity.name,
    email: entity.email,
    role: entity.role,
    profilePicture: entity.profilePicture,
    bio: entity.bio,
    enrolledCourses: entity.enrolledCourses,
    payments: entity.payments,
    blogPosts: entity.blogPosts,
    quizResults: entity.quizResults,
    reviews: entity.reviews,
    certificates: entity.certificates,
    searchHistory: entity.searchHistory,
    createdAt: entity.createdAt,
  );
}

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required UserModel user,
    @JsonKey(name: 'course_id') required String courseId,
    required int rating,
    required String comment,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);

  factory ReviewModel.fromEntity(ReviewEntity entity) => ReviewModel(
    id: entity.id,
    user: UserModel.fromEntity(entity.user),
    courseId: entity.courseId,
    rating: entity.rating,
    comment: entity.comment,
    createdAt: entity.createdAt,
  );
}
extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    name: name,
    email: email,
    role: role,
    profilePicture: profilePicture,
    bio: bio,
    enrolledCourses: enrolledCourses,
    payments: payments,
    blogPosts: blogPosts,
    quizResults: quizResults,
    reviews: reviews,
    certificates: certificates,
    searchHistory: searchHistory,
    createdAt: createdAt,
  );
}

extension ReviewModelMapper on ReviewModel {
  ReviewEntity toEntity() => ReviewEntity(
    id: id,
    user: user.toEntity(),
    courseId: courseId,
    rating: rating,
    comment: comment,
    createdAt: createdAt,
  );
}