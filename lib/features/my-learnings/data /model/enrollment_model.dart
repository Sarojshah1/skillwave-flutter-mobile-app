import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/my-learnings/domain/entity/enrollment_entity.dart';

part 'enrollment_model.freezed.dart';
part 'enrollment_model.g.dart';

@freezed
class EnrollmentModel with _$EnrollmentModel {
  const factory EnrollmentModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'course_id') required CourseModel course,
    required String status,
    required int progress,
    @JsonKey(name: 'enrollment_date') required DateTime enrollmentDate,
  }) = _EnrollmentModel;

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentModelFromJson(json);
}

extension EnrollmentModelX on EnrollmentModel {
  EnrollmentEntity toEntity() => EnrollmentEntity(
        id: id,
        userId: userId,
        course: course.toEntity(),
        status: status,
        progress: progress,
        enrollmentDate: enrollmentDate,
      );
}

@freezed
class CourseModel with _$CourseModel {
  const factory CourseModel({
    @JsonKey(name: '_id') required String id,
    required String title,
    required String description,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'category_id') required String categoryId,
    required int price,
    required String duration,
    required String level,
    required String thumbnail,
    required List<String> lessons,
    required List<String> quizzes,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

extension CourseModelX on CourseModel {
  CourseEntity toEntity() => CourseEntity(
        id: id,
        title: title,
        description: description,
        createdBy: createdBy,
        categoryId: categoryId,
        price: price,
        duration: duration,
        level: level,
        thumbnail: thumbnail,
        lessons: lessons,
        quizzes: quizzes,
      );
}
