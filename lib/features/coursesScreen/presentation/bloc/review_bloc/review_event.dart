part of 'review_bloc.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviewsByCourseId extends ReviewEvent {
  final String courseId;

  const LoadReviewsByCourseId(this.courseId);

  @override
  List<Object?> get props => [courseId];
}

class CreateReview extends ReviewEvent {
  final String courseId;
  final int rating;
  final String comment;

  const CreateReview({
    required this.courseId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [courseId, rating, comment];
}
