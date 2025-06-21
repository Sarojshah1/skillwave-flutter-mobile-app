import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart';
import 'package:skillwave/cores/failure/failure.dart';
import 'package:skillwave/features/coursesScreen/domain/entity/review_entity.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_payment_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/create_review_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_course_by_id_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_courses_usecase.dart';
import 'package:skillwave/features/coursesScreen/domain/usecase/get_reviews_by_course_id_usecase.dart';

part 'course_event.dart';
part 'course_state.dart';

@injectable
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetCourseByIdUseCase _getCourseByIdUseCase;
  final CreatePaymentUseCase _createPaymentUseCase;

  CourseBloc(
    this._getCoursesUseCase,
    this._getCourseByIdUseCase,
    this._createPaymentUseCase,
  ) : super(CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseById>(_onLoadCourseById);
    on<CreatePayment>(_onCreatePayment);
  }

  List<CourseEntity> _allCourses = [];
  bool _hasReachedMax = false;

  Future<void> _onLoadCourses(
    LoadCourses event,
    Emitter<CourseState> emit,
  ) async {
    if (_hasReachedMax && event.page != 1) {
      return;
    }
    try {
      if (event.page == 1) {
        emit(CourseLoading());
      }

      final result = await _getCoursesUseCase.call(
        page: event.page,
        limit: event.limit,
      );

      result.fold((failure) => emit(CourseError(failure)), (courses) {
        print(courses);
        if (event.page == 1) {
          _allCourses = courses ?? [];
        } else {
          _allCourses.addAll(courses ?? []);
        }

        _hasReachedMax = (courses == null || courses.length < event.limit);

        emit(CourseLoaded(courses: _allCourses, hasReachedMax: _hasReachedMax));
      });
    } catch (e) {
      emit(CourseError(ApiFailure(message: e.toString())));
    }
  }

  Future<void> _onLoadCourseById(
    LoadCourseById event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final response = await _getCourseByIdUseCase.call(event.courseId);

      response.fold(
        (error) => emit(CourseError(error)),
        (course) => emit(CourseByIdLoaded(course: course!)),
      );
    } catch (e) {
      emit(CourseError(ApiFailure(message: e.toString())));
    }
  }

  Future<void> _onCreatePayment(
    CreatePayment event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    try {
      final response = await _createPaymentUseCase.call(
        courseId: event.courseId,
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        status: event.status,
      );

      if (response.isSuccess) {
        emit(PaymentSuccess());
      } else {
        emit(
          CourseError(
            ApiFailure(message: response.failure?.message ?? 'Payment failed'),
          ),
        );
      }
    } catch (e) {
      emit(CourseError(ApiFailure(message: e.toString())));
    }
  }


}
