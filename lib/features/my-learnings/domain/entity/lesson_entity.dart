import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String content;
  final String videoUrl;
  final int order;

  const LessonEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.content,
    required this.videoUrl,
    required this.order,
  });

  @override
  List<Object?> get props => [id, courseId, title, content, videoUrl, order];
}
