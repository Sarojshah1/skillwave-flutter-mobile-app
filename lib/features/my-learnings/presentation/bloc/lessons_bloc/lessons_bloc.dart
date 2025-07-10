import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:skillwave/features/my-learnings/domain/usecases/get_lessons_usecase.dart';
import 'lessons_event.dart';
import 'lessons_state.dart';

@injectable
class LessonsBloc extends Bloc<LessonsEvent, LessonsState> {
  final GetLessonsUsecase getLessonsByCourseIdUseCase;

  LessonsBloc(this.getLessonsByCourseIdUseCase) : super(LessonsInitial()) {
    on<FetchLessonsEvent>(_onFetchLessons);
  }

  Future<void> _onFetchLessons(
    FetchLessonsEvent event,
    Emitter<LessonsState> emit,
  ) async {
    emit(LessonsLoading());
  
    final result = await getLessonsByCourseIdUseCase(event.courseId);
    result.fold(
      (failure) => emit(LessonsFailure(failure.message)),
      (lessons) => emit(LessonsLoaded(lessons ?? [])),
    );
  }
}
