import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    @JsonKey(name: 'created_by') required CreatedByModel createdBy,
    @JsonKey(name: 'category_id') required CategoryModel category,
    required int price,
    required String duration,
    required String level,
    required String thumbnail,
    required List<LessonModel> lessons,  // Changed from List<String> to List<LessonModel>
    required List<dynamic> quizzes,
    required List<dynamic> reviews,
    required List<dynamic> certificates,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

@freezed
class CreatedByModel with _$CreatedByModel {
  const factory CreatedByModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    required String password,
    required String role,
    @JsonKey(name: 'profile_picture') required String profilePicture,
    required String bio,
    @JsonKey(name: 'enrolled_courses') required List<String> enrolledCourses,
    required List<String> payments,
    @JsonKey(name: 'blog_posts') required List<String> blogPosts,
    @JsonKey(name: 'quiz_results') required List<dynamic> quizResults,
    required List<dynamic> reviews,
    required List<dynamic> certificates,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'search_history') required List<String> searchHistory,
  }) = _CreatedByModel;

  factory CreatedByModel.fromJson(Map<String, dynamic> json) =>
      _$CreatedByModelFromJson(json);
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String description,
    required String icon,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    required String content,
    @JsonKey(name: 'video_url') required String videoUrl,
    required int order,
    @JsonKey(name: '__v') int? v,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}

// Mappers to convert model to entity

extension CourseModelMapper on CourseModel {
  CourseEntity toEntity() {
    return CourseEntity(
      id: id,
      title: title,
      description: description,
      createdBy: createdBy.toEntity(),
      category: category.toEntity(),
      price: price,
      duration: duration,
      level: level,
      thumbnail: thumbnail,
      lessons: lessons.map((lesson) => lesson.toEntity()).toList(),
      quizzes: quizzes,
      reviews: reviews,
      certificates: certificates,
      createdAt: createdAt,
    );
  }
}

extension CreatedByModelMapper on CreatedByModel {
  CreatedByEntity toEntity() {
    return CreatedByEntity(
      id: id,
      name: name,
      email: email,
      password: password,
      role: role,
      profilePicture: profilePicture,
      bio: bio,
      enrolledCourses: enrolledCourses,
      payments: payments,
      blogPosts: blogPosts,
      quizResults: quizResults,
      reviews: reviews,
      certificates: certificates,
      createdAt: createdAt,
      searchHistory: searchHistory,
    );
  }
}

extension CategoryModelMapper on CategoryModel {
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      description: description,
      icon: icon,
    );
  }
}

extension LessonModelMapper on LessonModel {
  LessonEntity toEntity() {
    return LessonEntity(
      id: id,
      courseId: courseId,
      title: title,
      content: content,
      videoUrl: videoUrl,
      order: order,
      v: v,
    );
  }
}
