part of 'review_bloc.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewError extends ReviewState {
  final Failure failure;

  const ReviewError(this.failure);

  @override
  List<Object?> get props => [failure];
}

class ReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;

  const ReviewsLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewCreated extends ReviewState {}
