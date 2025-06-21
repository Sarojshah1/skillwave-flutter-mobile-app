import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_review_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_reviews_by_course_id_usecase.dart';
import 'package:skillwave/cores/failure/failure.dart';

part 'review_event.dart';
part 'review_state.dart';

@injectable
class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final CreateReviewUseCase _createReviewUseCase;
  final GetReviewsByCourseIdUseCase _getReviewsByCourseIdUseCase;

  ReviewBloc(this._createReviewUseCase, this._getReviewsByCourseIdUseCase)
      : super(ReviewInitial()) {
    on<LoadReviewsByCourseId>(_onLoadReviewsByCourseId);
    on<CreateReview>(_onCreateReview);
  }

  Future<void> _onLoadReviewsByCourseId(
      LoadReviewsByCourseId event,
      Emitter<ReviewState> emit,
      ) async {
    emit(ReviewLoading());
    try {
      final response = await _getReviewsByCourseIdUseCase.call(event.courseId);
      response.fold(
            (failure) {
              print(failure);
              emit(ReviewError(failure));
            },
            (reviews) {
              print(reviews);
              emit(ReviewsLoaded(reviews ?? []));
            },
      );
    } catch (e) {
      emit(ReviewError(ApiFailure(message: e.toString())));
    }
  }

  Future<void> _onCreateReview(
      CreateReview event,
      Emitter<ReviewState> emit,
      ) async {
    emit(ReviewLoading());
    try {
      final result = await _createReviewUseCase.call(
        courseId: event.courseId,
        rating: event.rating,
        comment: event.comment,
      );
      result.fold(
            (failure) => emit(ReviewError(failure)),
            (_) => emit(ReviewCreated()),
      );
    } catch (e) {
      emit(ReviewError(ApiFailure(message: e.toString())));
    }
  }
}
