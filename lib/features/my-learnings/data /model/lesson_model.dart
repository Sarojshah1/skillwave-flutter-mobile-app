import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel with _$LessonModel {
  const factory LessonModel({
    @JsonKey(name: '_id') required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    required String content,
    @JsonKey(name: 'video_url') required String videoUrl,
    required int order,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) => _$LessonModelFromJson(json);
}

extension LessonModelX on LessonModel {
  LessonEntity toEntity() => LessonEntity(
        id: id,
        courseId: courseId,
        title: title,
        content: content,
        videoUrl: videoUrl,
        order: order,
      );
}
